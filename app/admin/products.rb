ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock_quantity, :on_sale, :category_id

  index do
    selectable_column
    id_column
    column :name
    column :category
    column :price
    column :stock_quantity
    column :on_sale
    actions
  end

  filter :category
  filter :name
  filter :on_sale
end
