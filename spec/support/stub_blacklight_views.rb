module BlacklightStubbing
  def stub_blacklight_views # rubocop:disable Metrics/AbcSize
    allow(view).to receive(:dom_class).and_return('')
    allow(view).to receive(:can?).and_return(true)
    allow(view).to receive(:blacklight_config) \
      .and_return(CatalogController.new.blacklight_config)
    allow(view).to receive(:blacklight_configuration_context) \
      .and_return(Blacklight::Configuration::Context.new(controller))
    allow(view).to receive(:search_session).and_return({})
    allow(view).to receive(:current_search_session).and_return(nil)
  end
end

RSpec.configure do |config|
  config.include BlacklightStubbing
end
