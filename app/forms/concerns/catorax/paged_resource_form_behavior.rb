module Catorax
  module PagedResourceFormBehavior
    extend ActiveSupport::Concern
    # Add behaviors that make this work type unique

    included do
      self.terms += [:holding_location]
    end
  end
end