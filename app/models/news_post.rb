class NewsPost < ApplicationRecord
  has_rich_text :body

  scope :published, -> { where(published: true) }

  before_validation :set_slug
  before_validation :set_published_at, if: :published?

  validates :title, :body, :slug, presence: true
  validates :slug, uniqueness: true, format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ }

  private

  def set_slug
    self.slug = title.to_s.parameterize if slug.blank?
  end

  def set_published_at
    self.published_at ||= Time.current
  end
end
