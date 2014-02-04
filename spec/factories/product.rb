FactoryGirl.define do
  factory :products, class: Product do
    sequence(:name) { |n| "#{Faker::Lorem.word} #{n}" }
    price { Faker::Number.number(5) }
    sku_id { Faker::Number.number(5) }
    association :manufacturer, factory: :manufacturers
  end
end
