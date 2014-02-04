FactoryGirl.define do
  factory :manufacturers, class: Manufacturer do
    sequence(:name) { |n| "#{Faker::Company.name} #{n}" }
  end
end