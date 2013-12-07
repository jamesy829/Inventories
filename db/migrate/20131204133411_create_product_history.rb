class CreateProductHistory < ActiveRecord::Migration
  def change
    create_table :product_histories do |t|
      t.datetime :date
      t.integer :price
      t.integer :count
      t.integer :product_id

      t.timestamps
    end
  end
end
