class ProductsController < ApplicationController
  def index
    @categories = Category.order(:name)
    @products = Product.search(params[:q], params[:category_id])
                       .includes(:category).order(:name).page(params[:page]).per(9)
  end

  def show
    @product = Product.find(params[:id])
  end
end
