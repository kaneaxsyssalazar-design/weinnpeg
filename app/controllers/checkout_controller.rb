class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :require_items
  before_action :require_address

  # Shows the invoice (items, taxes for the user's province, total) before ordering.
  def new
    @order = Order.build_from_cart(cart_items, current_user)
  end

  def create
    order = Order.build_from_cart(cart_items, current_user)
    if order.save
      session[:cart] = {}
      redirect_to order_path(order), notice: "Order placed! Here is your invoice."
    else
      redirect_to checkout_path, alert: order.errors.full_messages.to_sentence
    end
  end

  private

  def require_items
    redirect_to cart_path, alert: "Your cart is empty." if cart_items.empty?
  end

  def require_address
    return if current_user.address.present? && current_user.province.present?

    redirect_to edit_user_registration_path, alert: "Please add your address and province before checking out."
  end
end