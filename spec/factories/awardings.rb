FactoryBot.define do
  factory :awarding do
    title { "Benefactor" }
    image { Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/image.jpeg", 'image/jpeg') }
    user { nil }
    question { nil }
  end
end
