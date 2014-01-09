class ProductHistory < ActiveRecord::Base
  scope :order_by_date, -> { order('date DESC')  }

  belongs_to :product
  validates :date, :count, :price, :product, presence: true
  validates :count, :price, numericality: { greater_than_or_equal_to: 0 }
end