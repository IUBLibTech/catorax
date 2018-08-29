# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImagePresenter < Hyrax::WorkShowPresenter
    def holding_location
      HoldingLocationRenderer.new(solr_document.holding_location).render
    end
  end
end
