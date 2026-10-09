xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  xml.url do
    xml.loc root_url
    xml.changefreq "weekly"
    xml.priority "1.0"
  end

  xml.url do
    xml.loc about_url
    xml.changefreq "monthly"
    xml.priority "0.8"
  end

  xml.url do
    xml.loc programs_url
    xml.changefreq "monthly"
    xml.priority "0.8"
  end

  @news_posts.each do |post|
    xml.url do
      xml.loc news_post_url(post.slug)
      xml.lastmod post.updated_at.utc.iso8601
      xml.changefreq "monthly"
      xml.priority "0.7"
    end
  end

  @galleries.each do |gallery|
    xml.url do
      xml.loc gallery_url(gallery)
      xml.lastmod gallery.updated_at.utc.iso8601
      xml.changefreq "monthly"
      xml.priority "0.6"
    end
  end
end
