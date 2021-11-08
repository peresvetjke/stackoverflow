require "rails_helper"

RSpec.describe QuestionsController, :type => :controller do
  
  describe "GET show" do
    it "finds question by id"
    it "finds question's answers"
    it "has new blank answer created"
    it "renders show template"
  end

  describe "GET new" do
    it "has new blank question created"
    it "renders new template"
  end

  describe "POST create" do
    context 'with valid params' do
      it "creates new question"
      it "renders show template with object created"
    end

    context 'with invalid params' do
      it "keeps count unchanged"
      it "renders show template with object unsaved"
    end
  end
end