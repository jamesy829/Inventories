class Manufacturer < ActiveRecord::Base
  validates :name, presence: true, length: { maximum: 256 }
end
