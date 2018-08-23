require 'spec_helper'
require 'rails_helper'

describe IngestFileJob do
  let(:file_set) { FactoryBot.create(:file_set) }
  let(:filename) { Rails.root.join("spec", "fixtures", "world.png").to_s }
  let(:user)     { FactoryBot.create(:user) }

  context 'when :store_original_files is false', :clean do
    it 'sets the mime_type to an external body redirect' do
      expect(CreateDerivativesJob).to receive(:perform_now) \
        .with(file_set, String, String)
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
      described_class.perform_now(file_set, filename, user,
                                  mime_type: 'image/png')
      expect(file_set.reload.original_file.mime_type).to include \
        "#{Catorax.config[:master_file_service_url]}"
    end
  end

  context 'when :store_original_files is true', :clean do
    it 'saves an image file to the member file_set' do
      expect(CharacterizeJob).to receive(:perform_later) \
        .with(file_set, String)
      allow(Catorax.config).to receive(:[]) \
        .with(:store_original_files) \
        .and_return(true)
      allow(Catorax.config).to receive(:[]) \
        .with(:create_hocr_files) \
        .and_return(true)
      allow(Catorax.config).to receive(:[]) \
        .with(:index_hocr_files) \
        .and_return(true)
      described_class.perform_now(file_set, filename, user,
                                  mime_type: 'image/png')
      expect(file_set.reload.original_file.mime_type).to include "image/png"
    end
  end
end
