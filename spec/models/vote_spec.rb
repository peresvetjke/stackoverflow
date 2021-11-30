require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe "validations" do
    it { is_expected.to validate_inclusion_of(:preference).in_array([true, false]) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:author) }
    it { is_expected.to belong_to(:votable) }
  end
end
