# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :product_history do
    date { DateTime.now }
    price { Faker::Number.number(2) }
    count { Faker::Number.number(2) }
    association :product 
  end
end
