# Generated via
#  `rails generate hyrax:work SpecialImage`
module Hyrax
  # Generated controller for SpecialImage
  class SpecialImagesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include Catorax::ImagesControllerBehavior
    self.curation_concern_type = ::SpecialImage

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::SpecialImagePresenter
  end
end
