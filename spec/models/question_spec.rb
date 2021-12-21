require 'rails_helper'

RSpec.describe Question, type: :model do
  include_examples "authorable"
  include_examples "votable"
  include_examples "commentable"
  
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
    it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
    it { is_expected.to have_many(:followers).class_name('User') }
  end

  it { is_expected.to accept_nested_attributes_for(:links) }
  it { is_expected.to accept_nested_attributes_for(:awarding) }

  it "have many attached files" do 
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe "#subscribe!" do
    let(:user)     { create(:user) }
    let(:question) { create(:question) }

    context "when unsubscribed" do
      it "creates subscription" do
        expect { question.subscribe!(user) } .to change(Subscription, :count).by(1)
      end
    end

    context "when subscribed" do
      let!(:subscription) { create(:subscription, question: question, user: user) }

      it "destroys subscription" do
        expect { question.subscribe!(user) } .to change(Subscription, :count).by(-1)
      end
    end
  end
end
