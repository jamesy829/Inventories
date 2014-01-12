FactoryGirl.define do
  factory :manufacturer do
    sequence(:name) { |n| "#{Faker::Company.name} #{n}" }
  end
end