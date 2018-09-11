require 'spec_helper'
require 'rails_helper'

describe Hyrax::Actors::FileActor do
  let(:file_set) { FactoryBot.create(:file_set) }
  let(:filename) { Rails.root.join("spec", "fixtures", "world.png").to_s }
  let(:user)     { FactoryBot.create(:user) }
  let(:file_actor) { described_class.new(file_set, :original_file, user) }
  let(:file) { File.new(filename) }
  let(:io) { JobIoWrapper.create_with_varied_file_handling!(user: user, file: file, relation: :original_file, file_set: file_set) }

  context 'when :store_original_files is false', :clean do
    it 'sets the mime_type to an external body redirect' do
      expect(CharacterizeJob).not_to receive(:perform_later)
      allow(Catorax.config).to receive(:[]) \
        .with(:store_original_files) \
        .and_return(false)
      allow(Catorax.config).to receive(:[]) \
        .with(:create_hocr_files) \
        .and_return(true)
      allow(Catorax.config).to receive(:[]) \
        .with(:index_hocr_files) \
        .and_return(true)
      allow(Catorax.config).to receive(:[]) \
        .with(:master_file_service_url) \
        .and_return('http://service')
      file_actor.ingest_file(io)
      expect(file_set.reload.original_file.mime_type).to include \
        "#{Catorax.config[:master_file_service_url]}"
    end
  end

  context 'when :store_original_files is true', :clean do
    it 'saves an image file to the member file_set' do
      expect(CharacterizeJob).to receive(:perform_later) \
        .with(file_set, String, String)
      allow(Catorax.config).to receive(:[]) \
        .with(:store_original_files) \
        .and_return(true)
      allow(Catorax.config).to receive(:[]) \
        .with(:create_hocr_files) \
        .and_return(true)
      allow(Catorax.config).to receive(:[]) \
        .with(:index_hocr_files) \
        .and_return(true)
      file_actor.ingest_file(io)
      expect(file_set.reload.original_file.mime_type).to include "image/png"
    end
  end
end
