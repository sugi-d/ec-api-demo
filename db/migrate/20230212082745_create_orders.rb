class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :item_id
      t.integer :user_id

      t.timestamps
    end

    add_index :orders, :item_id
    add_index :orders, :user_id
  end
end
