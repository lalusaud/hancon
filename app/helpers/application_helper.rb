module ApplicationHelper
  SITE_NAME = "HaNCON".freeze
  SITE_TITLE = "HaNCON | Hamilton Nepali Community Organization And Network".freeze
  SITE_DESCRIPTION = "HaNCON is a not-for-profit organization connecting Hamilton's Nepali-speaking community through culture, heritage, programs, and community support.".freeze
  DEFAULT_OG_IMAGE = "/images/community-hero.png".freeze

  def meta_robots_content
    content_for(:meta_robots) ||
      (controller_path.in?(%w[sessions passwords]) ? "noindex, nofollow" : "index, follow, max-image-preview:large, max-snippet:-1")
  end

  def seo_title
    content_for(:title) || SITE_TITLE
  end

  def seo_description
    content_for(:meta_description) || SITE_DESCRIPTION
  end

  def seo_url
    "#{request.base_url}#{request.path}"
  end

  def seo_og_image_url
    url = content_for(:og_image) || DEFAULT_OG_IMAGE
    url.match?(%r{\Ahttps?://}) ? url : "#{request.base_url}#{url}"
  end
end
