FactoryBot.define do
  factory :authentication do
    association :user, factory: :user
    provider { "facebook" }
    uid { "12345" }
  end
end
