require "rails_helper"

RSpec.describe AnswersController, :type => :controller do

  let(:user)     { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer)   { create(:answer, author: user, question: question) }

  describe "POST create" do

    context "when unauthorized" do

      it "renders log_in template" do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to(new_user_session_path)
      end 
    end

    context "when authorized" do
      before { login(user) }

      context 'with invalid params' do
        it "keeps count unchanged" do
          expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to change(question.answers, :count).by(0)
        end
        it "renders show question template with answer unsaved" do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
          expect(response).to render_template "questions/show"
        end
      end

      context 'with valid params' do
        it "creates new answer in db" do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question, author_id: user }}.to change(question.answers, :count).by(1)
        end       
        it "renders show question template with new answer created" do
          post :create, params: { answer: attributes_for(:answer), question_id: question }
          expect(response).to redirect_to(question)
        end
      end
    end
  end

  describe "DELETE destroy" do
    
    context "when unauthorized" do

      it "doesn't delete answer" do
        answer
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(0)
      end

      it "renders question show template" do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context "when authorized" do

      context "being not an author of question" do
        let(:other_user) { create(:user) }
        before { login(other_user) }

        it "doesn't delete question" do
          answer
          expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(0)
        end

        it "renders question show template" do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_path(question)
        end
      end

      context "being an author of answer" do
        before { login(user) }

        it "deletes question from db" do
          answer
          expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
        end        

        it "renders questions index template" do
          delete :destroy, params: { id: answer }
          expect(response).to redirect_to question_path(question)
        end
      end      
    end
  end
end