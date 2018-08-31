# Monkeypatch the stock actor for #ingest_file
module Hyrax
  module Actors
    class FileActor
      # Persists file as part of file_set and spawns async job to characterize and create derivatives.
      # @param [JobIoWrapper] io the file to save in the repository, with mime_type and original_name
      # @return [CharacterizeJob, FalseClass] spawned job on success, false on failure
      # @note Instead of calling this method, use IngestJob to avoid synchronous execution cost
      # @see IngestJob
      # @todo create a job to monitor the temp directory (or in a multi-worker system, directories!) to prune old files that have made it into the repo
      def ingest_file(io)
        # FIXME: pass along mimetype, filename options?
        if store_files?
          Hydra::Works::AddFileToFileSet.call(file_set,
                                              io,
                                              relation,
                                              versioning: false)
        else
          Hydra::Works::AddExternalFileToFileSet.call(file_set,
                                                      master_file_service_url,
                                                      relation,
                                                      versioning: false)
        end
        return false unless file_set.save
        repository_file = related_file
        Hyrax::VersioningService.create(repository_file, user)
        pathhint = io.uploaded_file.uploader.path if io.uploaded_file # in case next worker is on same filesystem
        CharacterizeJob.perform_later(file_set, repository_file.id, pathhint || io.path) if store_files?
      end

      private

        def store_files?
          Catorax.config[:store_original_files]
        end
    
        def master_file_service_url
          Catorax.config[:master_file_service_url]
        end
    end
  end
end
