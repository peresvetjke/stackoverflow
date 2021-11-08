FactoryBot.define do
  factory :user do
    email { "#{(0...10).map { ('a'..'z').to_a[rand(26)] }.join} + @" }
    password { "password" }
    login { "#{(0...10).map { ('a'..'z').to_a[rand(26)] }.join}" }
  end
end
