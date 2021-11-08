require "rails_helper"

RSpec.describe AnswersController, :type => :controller do

  describe "POST create" do
    context 'with valid params' do
      it "creates new answer"
      it "renders show question template with new answer created"
    end

    context 'with invalid params' do
      it "keeps count unchanged"
      it "renders show question template with answer unsaved"
    end
  end

  describe "POST create" do
    context 'with valid params' do
      it "creates new answer"
      it "renders show question template with new answer created"
    end

    context 'with invalid params' do
      it "keeps count unchanged"
      it "renders show question template with answer unsaved"
    end
  end
end