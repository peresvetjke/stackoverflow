FactoryBot.define do
  sequence :body do |n|
    "body #{n}"
  end

  factory :answer do
    association :question, factory: :question
    body
    association :author, factory: :user

    trait :invalid do
      body { nil }
    end

    trait :with_link do
      after(:create) do |answer|
        create(:link, linkable: answer)
      end
    end
  end
end