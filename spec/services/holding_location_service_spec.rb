require 'rails_helper'

RSpec.describe HoldingLocationService do
  let(:service) { described_class }

  let(:uri) { 'https://libraries.indiana.edu/music' }
  let(:contact_email) { 'libmus@indiana.edu' }
  let(:label) { 'William & Gayle Cook Music Library' }
  let(:phone_number) { '(812) 855-2970' }

  context "with rights statements" do
    it "gets the email of a holding location" do
      expect(service.find(uri).fetch('contact_email')).to eq(contact_email)
    end

    it "gets the label of a holding location" do
      expect(service.find(uri).fetch('label')).to eq(label)
    end

    it "gets the phone number of a holding location" do
      expect(service.find(uri).fetch('phone_number')).to eq(phone_number)
    end
  end
end
