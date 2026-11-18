class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :address, null: false
      t.string :city, null: false
      t.string :postal_code, null: false
      t.references :province, null: false, foreign_key: true
      t.timestamps
    end
  end
end
