FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password { "xxxxxxxx" }
    confirmed_at { Time.now }
  end

end
