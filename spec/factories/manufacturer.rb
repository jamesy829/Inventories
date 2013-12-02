FactoryGirl.define do
  factory :manufacturer do
    sequence(:name) { |n| "Name #{n}" }
  end
end