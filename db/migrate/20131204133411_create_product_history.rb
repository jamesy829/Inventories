class CreateProductHistory < ActiveRecord::Migration
  def change
    create_table :product_histories do |t|
      t.datetime :date
      t.integer :price
      t.integer :count
      t.references :product

      t.timestamps
    end

    add_index :product_histories, :product_id
  end
end
