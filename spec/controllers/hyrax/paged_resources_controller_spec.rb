# Generated via
#  `rails generate hyrax:work PagedResource`
require 'rails_helper'

RSpec.describe Hyrax::PagedResourcesController do
  routes { Rails.application.routes }
  let(:main_app) { Rails.application.routes.url_helpers }
  let(:hyrax) { Hyrax::Engine.routes.url_helpers }


  let(:user) { FactoryGirl.create(:user) }
  let(:paged_resource) {
    FactoryGirl.create(:paged_resource,
                       user: user, 
                       title: ['Dummy Title'])
  }
  let(:reloaded) { paged_resource.reload }

  before { sign_in user }

  describe 'update' do
    let(:static_attributes) {
      {
        description: ['a description'],
        source_metadata_identifier: 'BHR9405'
      }
    }

    context 'without remote refresh flag' do
      it 'updates the record but does not refresh the exernal metadata' do
        patch :update,
             params: { id: paged_resource.id,
                       paged_resource: static_attributes }
        expect(reloaded.title).to eq ['Dummy Title']
        expect(reloaded.description).to eq ['a description']
      end
    end

    context 'with remote refresh flag', vcr: { cassette_name: 'bibdata', record: :new_episodes } do
      it 'updates the record and refreshes the external metadata' do
        patch :update,
             params: { id: paged_resource.id,
                       paged_resource: static_attributes,
                       refresh_remote_metadata: true }
        expect(reloaded.title).to eq ['Fontane di Roma ; poema sinfonico per orchestra']
        expect(reloaded.description).to eq ['a description']
      end
    end
  end
end
