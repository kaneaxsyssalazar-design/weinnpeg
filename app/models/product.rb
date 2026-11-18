class Product < ApplicationRecord
  belongs_to :category
  has_many :order_items, dependent: :restrict_with_error
  has_one_attached :image

  validates :name, presence: true, length: { maximum: 120 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :stock_quantity, presence: true,
                             numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :on_sale, inclusion: { in: [true, false] }


  # Keyword search in title or description, optionally inside one category (2.6)
  def self.search(keyword, category_id)
    scope = all
    scope = scope.where(category_id: category_id) if category_id.present?
    if keyword.present?
      like = "%#{sanitize_sql_like(keyword.strip)}%"
      scope = scope.where("LOWER(products.name) LIKE LOWER(:q) OR LOWER(products.description) LIKE LOWER(:q)", q: like)
    end
    scope
  end
end
