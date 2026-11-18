class CheckoutController < ApplicationController
  before_action :require_items

  def new
    @customer = Customer.new
    @provinces = Province.order(:name)
  end

  def create
    @provinces = Province.order(:name)
    @customer = Customer.new(customer_params)
    unless @customer.valid?
      flash.now[:alert] = "Please fix the errors below."
      return render :new, status: :unprocessable_entity
    end

    order = Order.build_from_cart(cart_items, @customer)
    Order.transaction do
      @customer.save!
      order.customer = @customer
      order.save!
    end
    session[:cart] = {}
    redirect_to order_path(order), notice: "Order placed! Here is your invoice."
  end

  private

  def require_items
    redirect_to cart_path, alert: "Your cart is empty." if cart_items.empty?
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :address, :city, :postal_code, :province_id)
  end
end
