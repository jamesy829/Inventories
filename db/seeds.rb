require 'factory_girl_rails'
require 'faker'
require 'activerecord-import'
require 'ruby-progressbar'

manufacturers = []
progress = ProgressBar.create(title: 'Manufacturer', starting_at: 0, total: 50)

50.times do |i|
  manufacturers << Manufacturer.new(name: "#{Faker::Company.name} #{i}")
  progress.increment
end

Manufacturer.import manufacturers

progress = ProgressBar.create(title: 'Product', starting_at: 0, total: Manufacturer.count)

Manufacturer.all.each do |m|
  products = []

  50.times do |i|
    products << Product.new(name: "#{Faker::Lorem.word} #{i}",
                            price: Faker::Number.number(5),
                            sku_id: Faker::Number.number(5),
                            manufacturer: m)
  end

  progress.increment
  Product.import products
end

progress = ProgressBar.create(title: 'Product History', starting_at: 0, total: Product.count)

Product.all.each do |p|
  histories = []

  50.times do |i|
    histories << ProductHistory.new(date: DateTime.now,
                                    price: Faker::Number.number(5),
                                    count: Faker::Number.number(5),
                                    product: p)
  end

  progress.increment
  ProductHistory.import histories
end