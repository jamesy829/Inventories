require 'factory_girl_rails'
require 'faker'
require 'activerecord-import'
require 'ruby-progressbar'

namespace :seed do
  desc 'Drop and recreate database and run seed data'
  task :all =>  [
                  'db:reset',
                  'seed:manufacturer',
                  'seed:product',
                  'seed:product_history'
                ]

  desc 'Seed Manufacturer'
  task :manufacturer => :environment do
    count = ENV['count'] ? ENV['count'].to_i : 50
    manufacturers = []
    progress = ProgressBar.create(title: 'Manufacturer', starting_at: 0, total: 50)

    count.times do |i|
      manufacturers << Manufacturer.new(name: "#{Faker::Company.name} #{i}")
      progress.increment
    end

    Manufacturer.import manufacturers
  end

  desc 'Seed Product'
  task :product => :environment do
    count = ENV['count'] ? ENV['count'].to_i : 50
    progress = ProgressBar.create(title: 'Product', starting_at: 0, total: Manufacturer.count)

    Manufacturer.all.each do |m|
      products = []

      count.times do |i|
        products << Product.new(name: "#{Faker::Lorem.word} #{i}",
                                price: Faker::Number.number(5),
                                sku_id: Faker::Number.number(5),
                                manufacturer: m)
      end

      progress.increment
      Product.import products
    end
  end

  desc 'Seed Product History'
  task :product_history => :environment do
    count = ENV['count'] ? ENV['count'].to_i : 50
    progress = ProgressBar.create(title: 'Product History', starting_at: 0, total: Product.count)

    Product.all.each do |p|
      histories = []

      count.times do |i|
        histories << ProductHistory.new(date: DateTime.now,
                                        price: Faker::Number.number(5),
                                        count: Faker::Number.number(5),
                                        product: p)
      end

      progress.increment
      ProductHistory.import histories
    end
  end
end