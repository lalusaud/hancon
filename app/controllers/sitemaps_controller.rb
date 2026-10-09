class SitemapsController < ApplicationController
  allow_unauthenticated_access

  def show
    @news_posts = NewsPost.published.order(published_at: :desc)
    @galleries = Gallery.published.order(created_at: :desc)
    render "show", formats: :xml
  end
end
