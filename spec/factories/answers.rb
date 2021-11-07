FactoryBot.define do
  factory :answer do
    question { nil }
    body { "MyText" }
    author_id { 1 }
  end
end
