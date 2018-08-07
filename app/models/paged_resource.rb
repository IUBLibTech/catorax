# Generated via
#  `rails generate hyrax:work PagedResource`
class PagedResource < ActiveFedora::Base
  include Catorax::PagedResourceBehavior
  include ::Hyrax::WorkBehavior

  self.indexer = PagedResourceIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }

 # Include extended metadata common to most Work Types
  include Catorax::ExtendedMetadata

  # This model includes metadata properties specific to the PagedResource Work Type
  include Catorax::PagedResourceMetadata

  # Include properties for remote metadata lookup
  include Catorax::RemoteLookupMetadata

  # This must be included at the end, because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
end
