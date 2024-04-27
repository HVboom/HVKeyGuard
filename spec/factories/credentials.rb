FactoryBot.define do
  factory :credential do
    title { Faker::Alphanumeric.alpha(number: 10) }
    url { Faker::Internet.url }
    login { Faker::Internet.username }
    comment { Faker::Lorem.paragraph(random_sentences_to_add: 4) }
    secured { false }
  end
end
