class Order < ApplicationRecord
  STATUSES = %w[new paid shipped].freeze

  belongs_to :customer
  belongs_to :province
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :shipping_address, presence: true
  validates :subtotal, :gst_amount, :pst_amount, :hst_amount, :total_amount,
            presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :gst_rate, :pst_rate, :hst_rate, presence: true,
                                             numericality: { greater_than_or_equal_to: 0 }

  # Build an order from the session cart, copying prices and tax rates (snapshot).
  def self.build_from_cart(cart_items, customer)
    province = customer.province
    order = new(customer: customer, province: province,
                shipping_address: "#{customer.address}, #{customer.city}, #{province.code} #{customer.postal_code}",
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
