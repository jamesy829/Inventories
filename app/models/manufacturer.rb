class Manufacturer < ActiveRecord::Base
  has_many :products

  validates :name, presence: true, length: { maximum: 256 }
end
