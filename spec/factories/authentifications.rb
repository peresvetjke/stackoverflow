FactoryBot.define do
  factory :authentification do
    association :user, factory: :user
    provider { "facebook" }
    uid { "12345" }
  end
end
