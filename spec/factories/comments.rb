FactoryBot.define do
  trait :with_comments do
    after(:create) do |commentable|
      2.times { create(:comment, commentable: commentable) }
    end
  end
    
  factory :comment do
    body { "MyText" }
    commentable { nil }
    association :author, factory: :user
  end
end
