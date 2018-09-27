RSpec.shared_examples "page header" do |header_method, page_title|
  describe "page header" do
    let(:solr_document) { SolrDocument.new }
    let(:parent_id) { 'testid' }
    let(:presenter) { instance_double("presenter", solr_document: solr_document,
                                                   id: parent_id,
                                                   model_name: paged_resource.model_name,
                                                   to_model: paged_resource) }
    let(:paged_resource) do
      s = FactoryBot.build(:paged_resource)
      allow(s).to receive(:persisted?).and_return(true)
      allow(s).to receive(:id).and_return(parent_id)
      s
    end
    let(:parent_presenter) { instance_double("parent_presenter", solr_document: solr_document,
                                                                 id: "test",
                                                                 to_model: paged_resource,
                                                                 model_name: paged_resource.model_name,
                                                                 page_title: "Parent") }

    before do
      assign(:presenter, presenter)
      allow(presenter).to receive(:page_title).and_return('Test Resource')
    end

    describe 'page_header' do
      subject { subject_header }

      let(:subject_header) { helper.send header_method }
      let(:href) { Rails.application.routes.url_helpers
                        .hyrax_paged_resource_path(parent_id) }

      it { is_expected.to have_selector('h1', text: page_title) }
      it { is_expected.to have_link('Test Resource', href: href) }
      it { is_expected.to have_selector('ul.breadcrumb') }

      context "when there is no parent presenter" do
        it "returns two lis" do
          expect(subject_header).to have_selector("li", text: "Test Resource")
          expect(subject_header).to have_selector("li.active", text: page_title)
        end
      end
      context "when there is a parent presenter" do
        before do
          assign(:parent_presenter, parent_presenter)
        end
        it "returns three lis" do
          expect(subject_header).to have_selector("li", text: "Parent")
          expect(subject_header).to have_selector("li", text: "Test Resource")
          expect(subject_header).to have_selector("li.active", text: page_title)
        end
      end
    end
  end
end
