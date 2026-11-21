ActiveAdmin.register Order do
  permit_params :status
  actions :index, :show, :edit, :update
end
ActiveAdmin.register Order do
  permit_params :status
  actions :index, :show, :edit, :update

  index do
    selectable_column
    id_column
    column :user
    column :status
    column("Total") { |o| number_to_currency(o.total_amount) }
    column :created_at
    actions
  end

  filter :status, as: :select, collection: Order::STATUSES
  filter :created_at

  show do |order|
    attributes_table do
      row :id
      row("Customer") { order.user.full_name }
      row("Email") { order.user.email }
      row :shipping_address
      row :status
      row :created_at
    end

    panel "Products ordered" do
      table_for order.order_items.includes(:product) do
        column("Product") { |i| link_to i.product.name, admin_product_path(i.product) }
        column("Unit price") { |i| number_to_currency(i.unit_price) }
        column :quantity
        column("Line total") { |i| number_to_currency(i.line_total) }
      end
    end

    panel "Totals" do
      attributes_table_for order do
        row("Subtotal") { number_to_currency(order.subtotal) }
        row("GST") { number_to_currency(order.gst_amount) }
        row("PST") { number_to_currency(order.pst_amount) }
        row("HST") { number_to_currency(order.hst_amount) }
        row("Grand total") { number_to_currency(order.total_amount) }
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :status, as: :select, collection: Order::STATUSES, include_blank: false
    end
    f.actions
  end
end
