# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'FAKEPASSWORD'
    password_confirmation 'FAKEPASSWORD'
  end
end
