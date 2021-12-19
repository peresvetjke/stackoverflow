FactoryBot.define do
  factory :comment do
    body { "MyText" }
    commentable { nil }
    association :author, factory: :user
  end
end
