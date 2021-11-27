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

  let(:answer)        { create(:answer) }
  let(:gist_link)     { create(:link, linkable: answer, url: "https://gist.github.com/mfgering/0ae79212156d0eaf24c344d16e30c562") }
  let(:non_gist_link) { create(:link, linkable: answer, url: "https://google.com/") }

  describe "#gist?" do
    it "returns true with a gist link" do
      expect(gist_link.gist?).to be true
    end

    it "returns false with a non-gist link" do
      expect(non_gist_link.gist?).to be false
    end
  end

  describe "#gist_id" do
    it "returns gist_id" do
      expect(gist_link.gist_id).to eq('0ae79212156d0eaf24c344d16e30c562')
    end
  end
end
