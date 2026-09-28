class Gallery < ApplicationRecord
  has_many_attached :photos
  scope :published, -> { where(published: true) }

  validates :title, presence: true
  validate :photos_must_be_images

  private

  def photos_must_be_images
    photos.each do |photo|
      errors.add(:photos, "must be images") unless photo.content_type&.start_with?("image/")
    end
  end
end
