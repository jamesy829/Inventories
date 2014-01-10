class Product < ActiveRecord::Base
  belongs_to :manufacturer
  has_many :product_histories

  validates :name, :price, :sku_id, :manufacturer, presence: true
  validates :name, :sku_id, uniqueness: true
  validates :name, length: { maximum: 256 }
  validates :price, :sku_id, numericality: { greater_than_or_equal_to: 0 }
end
