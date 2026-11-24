Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  root "home#index"

  get  "age-gate", to: "age_gate#show", as: :age_gate
  post "age-gate", to: "age_gate#create"

  resources :products, only: %i[index show]
  resources :categories, only: :show

  get "about", to: "pages#show", defaults: { slug: "about" }, as: :about
get "contact", to: "pages#show", defaults: { slug: "contact" }, as: :contact
  get    "cart", to: "cart#show", as: :cart
  post   "cart/add/:product_id", to: "cart#add", as: :add_to_cart
  patch  "cart/update/:product_id", to: "cart#update", as: :update_cart_item
  delete "cart/remove/:product_id", to: "cart#remove", as: :remove_cart_item

  get  "checkout", to: "checkout#new", as: :checkout
  post "checkout", to: "checkout#create"
  get  "checkout/success", to: "checkout#success", as: :checkout_success
  get  "checkout/cancel", to: "checkout#cancel", as: :checkout_cancel
  resources :orders, only: %i[index show]
end
