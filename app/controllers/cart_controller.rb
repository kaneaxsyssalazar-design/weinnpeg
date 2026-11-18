class CartController < ApplicationController
  def show
    @items = cart_items
  end

  def add
    product = Product.find(params[:product_id])
    qty = [params.fetch(:quantity, 1).to_i, 1].max
    cart[product.id.to_s] = cart.fetch(product.id.to_s, 0) + qty
    redirect_back fallback_location: cart_path, notice: "#{product.name} added to your cart."
  end

  def update
    qty = params[:quantity].to_i
    if qty < 1
      redirect_to cart_path, alert: "Quantity must be at least 1. Use Remove to delete an item."
    else
      cart[params[:product_id].to_s] = qty
      redirect_to cart_path, notice: "Quantity updated."
    end
  end

  def remove
    cart.delete(params[:product_id].to_s)
    redirect_to cart_path, notice: "Item removed from your cart."
  end
end
