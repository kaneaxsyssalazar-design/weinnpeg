class ReplaceCustomersWithUsers < ActiveRecord::Migration[8.1]
  def up
    create_table :users do |t|
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.datetime :remember_created_at
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :address, null: false
      t.string :city, null: false
      t.string :postal_code, null: false
      t.references :province, null: false, foreign_key: true
      t.timestamps
    end
    add_index :users, :email, unique: true

    # Existing test orders belong to the old customers table, so clear them first.
    execute "DELETE FROM order_items"
    execute "DELETE FROM orders"
    remove_reference :orders, :customer, foreign_key: true, index: true
    add_reference :orders, :user, null: false, foreign_key: true
    drop_table :customers
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end