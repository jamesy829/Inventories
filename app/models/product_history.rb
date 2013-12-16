class ProductHistory < ActiveRecord::Base
  belongs_to :product
  validates :date, :count, :price, presence: true
  validates :count, :price, numericality: { greater_than_or_equal_to: 0 }
end
