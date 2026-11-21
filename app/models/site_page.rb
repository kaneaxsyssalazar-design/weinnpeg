class SitePage < ApplicationRecord
  SLUGS = %w[about contact].freeze

  validates :slug, presence: true, uniqueness: true, inclusion: { in: SLUGS }
  validates :title, presence: true, length: { maximum: 80 }
  validates :body, presence: true, length: { minimum: 20 }
end
