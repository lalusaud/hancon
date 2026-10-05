class Gallery < ApplicationRecord
  belongs_to :featured_photo_attachment, class_name: "ActiveStorage::Attachment", optional: true

  has_many_attached :photos do |attachable|
    attachable.variant :thumbnail, resize_to_limit: [480, 360], preprocessed: true
    attachable.variant :display, resize_to_limit: [1200, 1200], preprocessed: true
  end
  scope :published, -> { where(published: true) }

  validates :title, presence: true
  validate :photos_must_be_images, :featured_photo_must_belong_to_gallery

  def featured_photo
    featured_photo_attachment&.blob || photos.first
  end

  private

  def photos_must_be_images
    photos.each do |photo|
      errors.add(:photos, "must be images") unless photo.content_type&.start_with?("image/")
    end
  end

  def featured_photo_must_belong_to_gallery
    return if featured_photo_attachment_id.blank? || photos_attachments.exists?(id: featured_photo_attachment_id)

    errors.add(:featured_photo_attachment, "must be one of this gallery's photos")
  end
end
