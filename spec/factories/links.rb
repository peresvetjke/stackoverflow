FactoryBot.define do
  trait :with_link do
    after(:create) do |linkable|
      create(:link, linkable: linkable)
    end
  end
    
  factory :link do
    title { "Stackoverflow" }
    url { "https://stackoverflow.com/" }
    linkable { nil }
  end
end