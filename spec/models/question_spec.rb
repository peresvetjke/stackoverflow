require 'rails_helper'

RSpec.describe Question, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:author_id) }
    it { is_expected.to validate_uniqueness_of(:title) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:author).class_name('User') }
    it { is_expected.to have_many(:answers) }
  end
end
