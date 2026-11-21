ActiveAdmin.register User do
  actions :index, :show

  index do
    id_column
    column :full_name
    column :email
    column :city
    column :province
    column("Orders") { |u| u.orders.count }
    column :created_at
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :city
end
