class Order < ApplicationRecord
  STATUSES = %w[new paid shipped].freeze

  belongs_to :user
  belongs_to :province
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :shipping_address, presence: true
  validates :subtotal, :gst_amount, :pst_amount, :hst_amount, :total_amount,
            presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :gst_rate, :pst_rate, :hst_rate, presence: true,
                                             numericality: { greater_than_or_equal_to: 0 }

  # Build (not save) an order from the session cart. Prices and tax rates are
  # copied onto the order so later changes never alter past orders (3.3.2).
  def self.build_from_cart(cart_items, user)
    province = user.province
    order = new(user: user, province: province,
                shipping_address: "#{user.address}, #{user.city}, #{province.code} #{user.postal_code}",
                gst_rate: province.gst, pst_rate: province.pst, hst_rate: province.hst)
    cart_items.each do |product, qty|
      order.order_items.build(product: product, quantity: qty, unit_price: product.price)
    end
    order.subtotal = order.order_items.sum { |i| i.unit_price * i.quantity }
    order.gst_amount = (order.subtotal * order.gst_rate).round(2)
    order.pst_amount = (order.subtotal * order.pst_rate).round(2)
    order.hst_amount = (order.subtotal * order.hst_rate).round(2)
    order.total_amount = order.subtotal + order.gst_amount + order.pst_amount + order.hst_amount
    order
  end
end