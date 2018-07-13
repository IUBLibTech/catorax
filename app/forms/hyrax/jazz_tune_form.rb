# Generated via
#  `rails generate hyrax:work JazzTune`
module Hyrax
  # Generated form for JazzTune
  class JazzTuneForm < Hyrax::Forms::WorkForm
    self.model_class = ::JazzTune
    self.terms += [:resource_type]
    include Catorax::ImageFormBehavior
  end
end
