class Event < ApplicationRecord
  scope :published, -> { where(published: true) }

  validates :title, :description, :starts_at, presence: true
  validates :ends_at, comparison: { greater_than: :starts_at }, if: :ends_at?
end
