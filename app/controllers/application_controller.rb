class ApplicationController < ActionController::Base
  before_action :require_age_verification, unless: :admin_area?
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :cart_count

  protected

  def configure_permitted_parameters
    keys = %i[first_name last_name address city postal_code province_id]
    devise_parameter_sanitizer.permit(:sign_up, keys: keys)
    devise_parameter_sanitizer.permit(:account_update, keys: keys)
  end

  private

  def admin_area? = request.path.start_with?("/admin")

  def require_age_verification
    return if session[:age_verified]
    session[:return_to] = request.fullpath if request.get?
    redirect_to age_gate_path
  end

  # Cart lives in the session: { "product_id" => quantity }
  def cart = (session[:cart] ||= {})

  def cart_count = cart.values.sum

  def cart_items
    products = Product.where(id: cart.keys).index_by { |p| p.id.to_s }
    cart.filter_map { |id, qty| [ products[id], qty ] if products[id] }
  end
end
