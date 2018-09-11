class IngestFileJob < ActiveJob::Base
  queue_as Hyrax.config.ingest_queue_name

  # @param [FileSet] file_set
  # @param [String] filepath the cached file within the
  #   CurationConcerns.config.working_path.
  # @param [String,NilClass] mime_type
  # @param [User] user
  # @param [String] relation ('original_file')
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def perform(file_set, filepath, user, opts = {})
    relation = opts.fetch(:relation, :original_file).to_sym

    # Wrap in an IO decorator to attach passed-in options
    local_file =
      Hydra::Derivatives::IoDecorator.new(File.open(filepath, "rb"))
    local_file.mime_type = opts.fetch(:mime_type, nil)
    local_file.original_filename = opts.fetch(:filename, File.basename(filepath))

    # Tell AddFileToFileSet service to skip versioning because versions will
    # be minted by VersionCommitter (called by
    # save_characterize_and_record_committer) when necessary.
    if store_files?
      Hydra::Works::AddFileToFileSet.call(file_set,
                                          local_file,
                                          relation,
                                          versioning: false)
    else
      Hydra::Works::AddExternalFileToFileSet.call(file_set,
                                                  master_file_service_url,
                                                  relation,
                                                  versioning: false)
    end

    # Persist changes to the file_set
    file_set.save!
    file_set.in_works.each do |work|
      work.pending_uploads.where(file_name: local_file.original_filename)
          .destroy_all
    end

    repository_file = file_set.send(relation)

    # Do post file ingest actions
    Hyrax::VersioningService.create(repository_file, user)

    # Uses the stored binary, so only run if we are storing files
    CharacterizeJob.perform_later(file_set, repository_file.id) if store_files?

    # Ensure that this runs for files that are external, before the master
    # file is cleaned
    return if store_files?
    CreateDerivativesJob.perform_now(file_set,
                                     repository_file.id,
                                     filepath)
  end

  private

    def store_files?
      Catorax.config[:store_original_files]
    end

    def master_file_service_url
      Catorax.config[:master_file_service_url]
    end
end
