FactoryBot.define do
  factory :subscription do
    association :question, factory: :question
    association :user, factory: :user
  end
end
