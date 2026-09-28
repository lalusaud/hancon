class GalleriesController < ApplicationController
  allow_unauthenticated_access

  def show
    @gallery = Gallery.published.includes(photos_attachments: :blob).find(params[:id])
  end
end
