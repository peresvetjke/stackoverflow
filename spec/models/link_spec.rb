require 'rails_helper'

RSpec.describe Link, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.not_to allow_value('asd').for(:url) }
  end

  describe "associations" do
    it { is_expected.to belong_to(:linkable) }
  end
end
