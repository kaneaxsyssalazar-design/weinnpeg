class CheckoutController < ApplicationController
  before_action :authenticate_user!
  before_action :require_items, only: %i[new create]
  before_action :require_address, only: %i[new create]

  # Shows the invoice (items, taxes for the user's province, total) before paying.
  def new
    @order = Order.build_from_cart(cart_items, current_user)
  end

  # Saves the order as "new", then sends the customer to Stripe to pay.
  def create
    order = Order.build_from_cart(cart_items, current_user)
    if order.save
      start_stripe_payment(order)
    else
      redirect_to checkout_path, alert: order.errors.full_messages.to_sentence
    end
  end

  # Stripe sends the customer back here after a successful payment.
  def success
    order = current_user.orders.find_by!(stripe_session_id: params[:session_id])
    stripe_session = Stripe::Checkout::Session.retrieve(order.stripe_session_id)

    if stripe_session.payment_status == "paid"
      order.update!(status: "paid")
      session[:cart] = {}
      redirect_to order_path(order), notice: "Payment received! Here is your invoice."
    else
      redirect_to checkout_path, alert: "Your payment was not completed."
    end
  end

  def cancel
    current_user.orders.find_by(id: params[:order_id], status: "new")&.destroy
    redirect_to checkout_path, alert: "Payment cancelled. Your cart is still saved."
  end

  private

  def start_stripe_payment(order)
    stripe_session = Stripe::Checkout::Session.create(
      mode: "payment",
      line_items: stripe_line_items(order),
      customer_email: current_user.email,
      metadata: { order_id: order.id },
      success_url: "#{checkout_success_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: checkout_cancel_url(order_id: order.id)
    )
    order.update!(stripe_session_id: stripe_session.id)
    redirect_to stripe_session.url, allow_other_host: true, status: :see_other
  rescue Stripe::StripeError => e
    order.destroy
    redirect_to checkout_path, alert: "Payment error: #{e.message}"
  end

  def stripe_line_items(order)
    items = order.order_items.map do |item|
      stripe_line(item.product.name, item.unit_price, item.quantity)
    end
    taxes = { "GST" => order.gst_amount, "PST" => order.pst_amount, "HST" => order.hst_amount }
    taxes.each do |label, amount|
      items << stripe_line("#{label} (#{order.province.code})", amount, 1) if amount.positive?
    end
    items
  end

  def stripe_line(name, amount, quantity)
    {
      quantity: quantity,
      price_data: {
        currency: "cad",
        unit_amount: (amount * 100).round.to_i,
        product_data: { name: name }
      }
    }
  end

  def require_items
    redirect_to cart_path, alert: "Your cart is empty." if cart_items.empty?
  end

  def require_address
    return if current_user.address.present? && current_user.province.present?

    redirect_to edit_user_registration_path, alert: "Please add your address and province before checking out."
  end
end
