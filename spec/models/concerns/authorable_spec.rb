require "rails_helper"

RSpec.shared_examples_for "authorable" do
  describe "associations" do
    it { is_expected.to belong_to(:author) }
  end

  let(:user)              { create(:user) }
  let(:to_sym)            { described_class.name.downcase.to_sym }
  let(:authorable)        { create(to_sym, author: user) }
  let(:other_authorable)  { create(to_sym) }
  
  context "when user is an author" do
    it "returns true" do
      expect(user.author_of?(authorable)).to be true
    end
  end

  context "when user is not an author" do
    it "returns false" do
      expect(user.author_of?(other_authorable)).to be false
    end
  end
end