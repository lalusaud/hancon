module Admin
  class GalleriesController < BaseController
    before_action :set_gallery, only: %i[edit update destroy]

    def index
      @galleries = Gallery.includes({ featured_photo_attachment: :blob }, photos_attachments: :blob).order(updated_at: :desc)
    end

    def new
      @gallery = Gallery.new
    end

    def create
      attributes = gallery_params
      @gallery = Gallery.new(attributes.except(:photos, :remove_photo_attachment_ids, :featured_photo_attachment_id))
      @gallery.photos = uploaded_photos
      if @gallery.save
        set_default_featured_photo
        redirect_to admin_galleries_path, notice: "Gallery saved."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      attributes = gallery_params
      removed_ids = attributes.fetch(:remove_photo_attachment_ids, []).reject(&:blank?).map(&:to_i)
      @gallery.assign_attributes(attributes.except(:photos, :remove_photo_attachment_ids))
      new_photos = uploaded_photos
      @gallery.photos = @gallery.photos.blobs + new_photos if new_photos.any?

      if @gallery.save
        if @gallery.featured_photo_attachment_id.present? && removed_ids.include?(@gallery.featured_photo_attachment_id.to_i)
          @gallery.update_column(:featured_photo_attachment_id, nil)
          @gallery.featured_photo_attachment_id = nil
        end
        @gallery.photos_attachments.where(id: removed_ids).each(&:purge)
        set_default_featured_photo
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
      params.require(:gallery).permit(:title, :description, :published, :featured_photo_attachment_id, photos: [], remove_photo_attachment_ids: [])
    end

    def uploaded_photos
      gallery_params.fetch(:photos, []).reject(&:blank?)
    end

    def set_default_featured_photo
      return if @gallery.featured_photo_attachment_id.present?

      first_photo_id = @gallery.photos_attachments.order(:id).pick(:id)
      @gallery.update_column(:featured_photo_attachment_id, first_photo_id) if first_photo_id
    end
  end
end
