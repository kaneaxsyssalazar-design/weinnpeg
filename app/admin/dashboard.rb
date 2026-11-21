ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Store at a glance" do
          ul do
            li "Products: #{Product.count}"
            li "Orders: #{Order.count}"
            li "Revenue (all orders): #{number_to_currency(Order.sum(:total_amount))}"
          end
        end
      end
      column do
        panel "Low stock (under 20)" do
          table_for Product.where("stock_quantity < 20").order(:stock_quantity).limit(10) do
            column(:name) { |p| link_to p.name, admin_product_path(p) }
            column :stock_quantity
          end
        end
      end
    end

    panel "Recent orders" do
      table_for Order.order(created_at: :desc).limit(10) do
        column("Order") { |o| link_to "##{o.id}", admin_order_path(o) }
        column :status
        column("Total") { |o| number_to_currency(o.total_amount) }
        column :created_at
      end
    end
  end
end
