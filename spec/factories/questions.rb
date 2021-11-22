FactoryBot.define do
  sequence :title do |n|
    "title #{n}"
  end

  factory :question do
    title
    body
    association :author, factory: :user
    # files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb')) }

    trait :invalid do
      title { nil }
    end

    trait :with_attachment do
      files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb')) }
    end
    #trait :with_attachment do
    #  after(:build) do |question|
    #    self.files.attach(
    #      io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
    #      filename: 'rails_helper.rb'
    #    )
    #  end
    #end
  end
end