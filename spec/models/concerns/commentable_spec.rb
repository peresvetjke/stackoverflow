require "rails_helper"

RSpec.shared_examples_for "commentable" do
  describe "associations" do
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end
end