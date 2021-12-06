require "rails_helper"

RSpec.shared_examples_for "authorable" do
  describe "associations" do
    it { is_expected.to belong_to(:author) }
  end
end