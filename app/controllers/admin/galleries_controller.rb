module Admin
  class GalleriesController < BaseController
    before_action :set_gallery, only: %i[edit update destroy]

    def index
      @galleries = Gallery.includes(photos_attachments: :blob).order(updated_at: :desc)
    end

    def new
      @gallery = Gallery.new
    end

    def create
      attributes = gallery_params
      @gallery = Gallery.new(attributes.except(:photos))
      @gallery.photos = uploaded_photos
      if @gallery.save
        redirect_to admin_galleries_path, notice: "Gallery saved."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      attributes = gallery_params
      @gallery.assign_attributes(attributes.except(:photos))
      new_photos = uploaded_photos
      @gallery.photos = @gallery.photos.blobs + new_photos if new_photos.any?

      if @gallery.save
        redirect_to admin_galleries_path, notice: "Gallery saved."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @gallery.destroy
      redirect_to admin_galleries_path, notice: "Gallery deleted."
    end

    private

    def set_gallery
      @gallery = Gallery.find(params[:id])
    end

    def gallery_params
      params.require(:gallery).permit(:title, :description, :published, photos: [])
    end

    def uploaded_photos
      gallery_params.fetch(:photos, []).reject(&:blank?)
    end
  end
end
