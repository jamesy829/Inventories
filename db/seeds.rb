# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'factory_girl_rails'
require 'faker'

puts "*************** Seeding Manufacturer *****************"
FactoryGirl.create_list(:manufacturer, 50)

puts "*************** Seeding Product *****************"
Manufacturer.all.each do |m|
  puts "**** Seeding Product for Manufacturer = #{m.name} ***"
  FactoryGirl.create_list(:product, 50, manufacturer: m)
end

puts "*************** Seeding Product History *****************"
Product.all.each do |p|
  puts "**** Seeding Product History for Product = #{p.name} ***"
  FactoryGirl.create_list(:product_history, 50, product: p)
end