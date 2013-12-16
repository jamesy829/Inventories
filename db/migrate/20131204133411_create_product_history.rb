class CreateProductHistory < ActiveRecord::Migration
  def change
    create_table :product_histories do |t|
      t.datetime :date
      t.integer :price
      t.integer :count
      t.references :product, index: true
      t.foreign_key :products
      t.timestamps
    end
  end
end
