require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    # it { is_expected.to validate_presence_of(:login) }

    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    # it { is_expected.to validate_uniqueness_of(:login) }
    it { is_expected.not_to allow_value('asd').for(:email) }
  end

  describe "associations" do
    it { is_expected.to have_many(:questions) }
    it { is_expected.to have_many(:answers) }
  end
end
