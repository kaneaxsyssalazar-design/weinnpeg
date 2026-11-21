class User < ApplicationRecord
  # Devise hashes and salts passwords with bcrypt.
  devise :database_authenticatable, :registerable, :rememberable, :validatable

  belongs_to :province
  has_many :orders, dependent: :restrict_with_error

  validates :first_name, :last_name, :address, :city, presence: true, length: { maximum: 100 }
  validates :postal_code, presence: true,
                          format: { with: /\A[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d\z/,
                                    message: "must be a valid Canadian postal code" }

  def full_name = "#{first_name} #{last_name}"

  # Keep password columns out of ActiveAdmin search and filters.
  def self.ransackable_attributes(_auth_object = nil)
    %w[email first_name last_name city created_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[orders province]
  end
end