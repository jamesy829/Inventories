require 'factory_girl_rails'
require 'faker'
require 'activerecord-import'

a = Time.now
puts "*************** Seeding Manufacturer *****************"
manufacturers = []
50.times do |i|
  manufacturers << Manufacturer.new(name: "#{Faker::Company.name} #{i}")
end

Manufacturer.import manufacturers

puts "*************** Seeding Product *****************"
Manufacturer.all.each do |m|
  puts "**** Seeding Product for Manufacturer [#{m.id}] ***"
  products = []

  50.times do |i|
    products << Product.new(name: "#{Faker::Lorem.word} #{i}",
                            price: Faker::Number.number(5),
                            sku_id: Faker::Number.number(5),
                            manufacturer: m)
  end

  Product.import products
end

puts "*************** Seeding Product History *****************"
Product.all.each do |p|
  puts "**** Seeding Product History for Product [#{p.id}] ***"
  histories = []

  50.times do |i|
    histories << ProductHistory.new(date: DateTime.now,
                                    price: Faker::Number.number(5),
                                    count: Faker::Number.number(5),
                                    product: p)
  end

  ProductHistory.import histories
end
b= Time.now

puts b-a