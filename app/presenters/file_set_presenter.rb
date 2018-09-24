class FileSetPresenter < Hyrax::FileSetPresenter
  include Hyrax::Serializers
  delegate :viewing_hint,
           :title,
           :file_label,
           :width,
           :height,
           :full_text,
           :has?,
           to: :solr_document

  def thumbnail_id
    id
  end
end
