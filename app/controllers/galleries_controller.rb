class GalleriesController < ApplicationController
  allow_unauthenticated_access

  def index
    @galleries = Gallery.published.includes({ featured_photo_attachment: :blob }, photos_attachments: :blob).order(created_at: :desc)
  end

  def show
    @gallery = Gallery.published.includes(photos_attachments: :blob).find(params[:id])
  end
end
