require 'rails_helper'

RSpec.describe Awarding, type: :model do
  
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:image) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:question) }
    it { is_expected.to belong_to(:user).optional }
  end  

  it "have one attached file" do 
    expect(Awarding.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end