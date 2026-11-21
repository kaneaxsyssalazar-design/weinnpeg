class ProductsController < ApplicationController
  def index
  @categories = Category.order(:name)
  products = Product.search(params[:q], params[:category_id])
  products = products.discounted if params[:filter] == "on_sale"
  products = products.newly_added if params[:filter] == "new"
  @products = products.includes(:category).order(:name).page(params[:page]).per(9)
end
end
