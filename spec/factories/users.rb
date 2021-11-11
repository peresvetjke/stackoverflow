FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password { "xxxxxx" }
    confirmation_password { "xxxxxx" }
    login { "#{(0...10).map { ('a'..'z').to_a[rand(26)] }.join}" }
    
    trait :blank_email do
      email { nil }
    end 

    trait :blank_password do
      password { nil }
    end

  end


end
