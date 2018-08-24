# Refactor as custom actor
class IngestYAMLJob < ActiveJob::Base
  queue_as Hyrax.config.ingest_queue_name

  # @param [File] yaml_file
  # @param [User] user
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def perform(yaml_file, user, opts = {})
    logger.info "Ingesting YAML #{yaml_file}"
    @yaml_file = yaml_file
    @yaml = File.open(yaml_file) { |f| Psych.load(f) }
    @user = user
    @file_association_method = opts[:file_association_method] || :batch
    ingest
  end

  private
    def ingest
      resource = @yaml[:resource].constantize.new

      if @yaml[:attributes].present?
        @yaml[:attributes].each_value do |attributes|
          resource.attributes = attributes
        end
      end

      if @yaml[:source_metadata].present?
        resource.source_metadata = @yaml[:source_metadata]
      end

      # add thumbnail_path?
      # add collections?
      resource.save!

      if @yaml[:files].present?
        @yaml[:files].each do |file|
          file_set = FileSet.new
          file_set.attributes = file[:attributes] if file[:attributes].present?
          file_set.save!

          resource.ordered_members << file_set
          resource.save

          yaml_to_repo_map[file[:id]] = file_set.id
          IngestLocalFileJob.perform_now(file_set, file[:path], @user)
          # conditionally attach ocr
        end
      end

      if @yaml[:structure].present?
        @structure = map_fileids(@yaml[:structure]).to_json
        SaveStructureJob.perform_now(resource, @structure)
      end
    end

    def map_fileids(hsh)
      hsh.each do |k, v|
        hsh[k] = v.each { |node| map_fileids(node) } if k == :nodes
        hsh[k] = yaml_to_repo_map[v] if k == :proxy
      end
    end

    def yaml_to_repo_map
      @yaml_to_repo_map ||= {}
    end
end
