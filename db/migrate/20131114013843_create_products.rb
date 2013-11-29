class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.float :price
      t.integer :sku_id
      t.references :manufacturer, index: true
      t.timestamps
    end
  end
end
