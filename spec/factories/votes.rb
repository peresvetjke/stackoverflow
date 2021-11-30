FactoryBot.define do
  factory :vote do
    association :votable, factory: :question
    preference { false }
    author_id { 1 }
  end
end
