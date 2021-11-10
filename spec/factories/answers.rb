FactoryBot.define do
  factory :answer do
    association :question, factory: :question
    body { "#{(0...50).map { ('a'..'z').to_a[rand(26)] }.join}" }
    # association :author, factory: :user

    trait :invalid do
      body { nil }
    end
  end
end