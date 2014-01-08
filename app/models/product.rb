class Product < ActiveRecord::Base
  belongs_to :manufacturer
  has_many :product_history

  validates :name, presence: true, length: { maximum: 256 }, uniqueness: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :sku_id, presence: true, uniqueness: true, numericality: { greater_than_or_equal_to: 0 }
  validates :manufacturer, presence: true
end
