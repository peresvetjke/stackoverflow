FactoryBot.define do
  factory :link do
    title { "Stackoverflow" }
    url { "https://stackoverflow.com/" }
    linkable { nil }
  end
end
