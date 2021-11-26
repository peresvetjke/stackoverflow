require 'rails_helper'

RSpec.describe Question, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_uniqueness_of(:title) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:author).class_name('User') }
    it { is_expected.to have_many(:answers).dependent(:destroy) }
    it { is_expected.to have_many(:links).dependent(:destroy) }
    it { is_expected.to have_one(:awarding).optional }
  end

  it { is_expected.to accept_nested_attributes_for(:links) }
  it { is_expected.to accept_nested_attributes_for(:awardings) }

  it "have many attached files" do 
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
