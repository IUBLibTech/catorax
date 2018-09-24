module HyraxHelper
  include ::BlacklightHelper
  #include Hyrax::MainAppHelpers

  def default_icon_fallback
    safe_join ["this.src='", image_path('default.png'), "'"]
  end
end
