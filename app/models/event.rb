class Event < ApplicationRecord
  has_rich_text :description

  scope :published, -> { where(published: true) }

  validates :title, :starts_at, presence: true
  validate :description_must_include_text_or_attachment
  validates :ends_at, comparison: { greater_than: :starts_at }, if: :ends_at?

  private

  def description_must_include_text_or_attachment
    body = rich_text_description&.body
    return if body&.to_plain_text&.present? || body&.attachments&.any?

    errors.add(:description, :blank)
  end
end
