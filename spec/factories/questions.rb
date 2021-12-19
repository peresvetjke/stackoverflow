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

    trait :with_link do
      after(:create) do |question|
        create(:link, linkable: question)
      end
    end

    trait :with_comments do
      after(:create) do |question|
        2.times { create(:comment, commentable: question) }
      end
    end    
  end
end