class Province < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  has_many :orders, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, length: { is: 2 }, uniqueness: true
  validates :gst, :pst, :hst, presence: true,
                              numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
end