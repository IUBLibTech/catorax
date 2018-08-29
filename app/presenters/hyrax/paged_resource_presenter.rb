# Generated via
#  `rails generate hyrax:work PagedResource`
module Hyrax
  class PagedResourcePresenter < Hyrax::WorkShowPresenter
    def logical_order_object
      @logical_order_object ||=
          logical_order_factory.new(logical_order, nil, logical_order_factory)
    end
    def holding_location
      HoldingLocationRenderer.new(solr_document.holding_location).render
    end
  end
end
