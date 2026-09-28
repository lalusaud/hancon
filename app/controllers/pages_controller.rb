class PagesController < ApplicationController
  allow_unauthenticated_access

  def home
    @news = NewsPost.published.order(published_at: :desc).limit(3)
    @events = Event.published.where("starts_at >= ?", Time.current).order(:starts_at).limit(3)
    @galleries = Gallery.published.includes(photos_attachments: :blob).order(created_at: :desc).limit(3)
  end
end
