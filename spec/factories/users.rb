FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    name { Faker::Alphanumeric.alpha(number: 10) }
    password { Faker::Internet.password(min_length: 8, max_length: 12, mix_case: true, special_characters: true) }
    password_confirmation { password }
  end
end
