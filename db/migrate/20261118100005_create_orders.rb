class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :province, null: false, foreign_key: true
      t.string :status, null: false, default: "new"
      t.text :shipping_address, null: false
      # Snapshots so later price/tax changes never alter past orders (3.3.2)
      t.decimal :subtotal, precision: 10, scale: 2, null: false
      t.decimal :gst_rate, precision: 6, scale: 5, null: false, default: 0
      t.decimal :pst_rate, precision: 6, scale: 5, null: false, default: 0
      t.decimal :hst_rate, precision: 6, scale: 5, null: false, default: 0
      t.decimal :gst_amount, precision: 10, scale: 2, null: false, default: 0
      t.decimal :pst_amount, precision: 10, scale: 2, null: false, default: 0
      t.decimal :hst_amount, precision: 10, scale: 2, null: false, default: 0
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.timestamps
    end
  end
end
