FactoryBot.define do
  factory :link do
    title { "Google" }
    url { "https://www.google.com/" }
    linkable { nil }
  end
end
