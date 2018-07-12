# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImagePresenter < Hyrax::WorkShowPresenter
    delegate :woodcutter, to: :solr_document
  end
end
