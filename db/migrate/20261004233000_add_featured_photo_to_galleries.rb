class AddFeaturedPhotoToGalleries < ActiveRecord::Migration[8.1]
  def change
    add_reference :galleries, :featured_photo_attachment,
      foreign_key: { to_table: :active_storage_attachments }
  end
end
