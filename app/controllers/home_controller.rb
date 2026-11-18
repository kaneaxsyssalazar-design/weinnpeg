class HomeController < ApplicationController
  def index
    @categories = Category.order(:name)
    @featured = Product.order(created_at: :desc).limit(8)
  end
end
