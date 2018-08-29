# Generated via
#  `rails generate hyrax:work BibRecord`
module Hyrax
  class BibRecordPresenter < Hyrax::WorkShowPresenter
    def holding_location
      HoldingLocationRenderer.new(solr_document.holding_location).render
    end
  end
end
