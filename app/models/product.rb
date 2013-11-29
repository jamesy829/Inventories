class Product < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 256 }, uniqueness: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :sku_id, presence: true, uniqueness: true

  belongs_to :manufacturer
end
