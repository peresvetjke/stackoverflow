FactoryBot.define do
  sequence :title do |n|
    "title #{n}"
  end

  factory :question do
    title
    body
    association :author, factory: :user

    trait :invalid do
      title { nil }
    end

    trait :with_answers do
      after(:create) do |question|
        2.times { create(:answer, question: question) }
      end
    end
  end
end