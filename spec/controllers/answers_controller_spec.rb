require "rails_helper"

RSpec.describe AnswersController, :type => :controller do

  describe "POST create" do
    let (:question) { create(:question) }

    context 'with valid params' do
      it "creates new answer in db" do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question }}.to change(question.answers, :count).by(1)
      end

      it "renders show question template with new answer created" do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to(question)
      end
    end

    context 'with invalid params' do
      it "keeps count unchanged" do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to change(question.answers, :count).by(0)
      end

      it "renders show question template with answer unsaved" do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template "questions/show"
      end
    end
  end
end