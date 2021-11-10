FactoryBot.define do
  factory :question do
    title { "#{(0...10).map { ('a'..'z').to_a[rand(26)] }.join}" }
    body  { "#{(0...10).map { ('a'..'z').to_a[rand(26)] }.join}" }
    # association :author, factory: :user

    trait :invalid do
      title { nil }
    end
  end
end