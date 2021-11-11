FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    email
    password { "xxxxxxxx" }
    
    trait :blank_email do
      email { nil }
    end 

    trait :blank_password do
      password { nil }
    end

  end


end
