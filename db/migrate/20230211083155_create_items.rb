class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.text :description
      t.integer :price
      t.integer :user_id

      t.timestamps
    end

    add_index :items, :user_id
  end
end
