# Generated via
#  `rails generate hyrax:work JazzTune`
module Hyrax
  # Generated controller for JazzTune
  class JazzTunesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    include Catorax::ImagesControllerBehavior
    self.curation_concern_type = ::JazzTune

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::ImagePresenter
  end
end
