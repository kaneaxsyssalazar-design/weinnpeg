class Category < ApplicationRecord
  has_many :products, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true, length: { maximum: 60 }
  validates :description, presence: true, length: { maximum: 500 }
end
