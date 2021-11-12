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
  end
end