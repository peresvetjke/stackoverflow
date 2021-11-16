require "rails_helper"

RSpec.describe QuestionsController, :type => :controller do

  let (:user)     { create(:user) }
  let (:question) { create(:question, author: user) }

  describe "GET show" do
    it "renders show template" do
      get :show, params: { id: question }
      expect(response).to render_template(:show)
    end
  end

  describe "GET new" do
    context "when unauthorized" do
      it "renders log_in template" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end      
    end

    context "when authorized" do
      before { login(user) }

      it "renders new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST create" do    
    context "when unauthorized" do
      it "keeps count unchanged" do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(0)
      end

      it "renders log_in template" do 
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authorized" do
      before {
        user = create(:user)
        login(user)
      }

      context 'with invalid params' do
        it "keeps count unchanged" do
          expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to change(Question, :count).by(0)
        end
       
        it "renders new template" do
          post :create, params: { question: attributes_for(:question, :invalid) }
          expect(response).to render_template :new
        end
      end

      context 'with valid params' do
        it "creates new question in db" do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        end

        it "renders show template with object created" do 
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to(controller.question)
        end
      end
    end
  end

# edit-update / BEGIN

  describe "GET edit" do
    context "when unauthorized" do
      it "renders log_in template" do
        get :edit, params: { id: question }
        expect(response).to redirect_to(new_user_session_path)
      end      
    end

    context "when authorized" do           # being an author - and not
      context "being not an author of question" do
        before { 
          other_user = create(:user)
          login(other_user)
        }

        it "redirects to show question" do
          get :edit, params: { id: question }
          expect(response).to redirect_to question_path(question)
        end
      end

      context "being an author of question" do
        before { login(user) }

        it "renders edit template" do
          get :edit, params: { id: question }
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe "PATCH update" do    
    context "when unauthorized" do
      it "keeps unchanged" do
        patch :update, params: { id: question, question: attributes_for(:question, body: "corrections") }
        question.reload
        expect(question.body).to eq(question.body)
      end

      it "renders log_in template" do 
        patch :update, params: { id: question, question: attributes_for(:question, body: "corrections") }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when authorized" do
      context "being not an author of question" do
        before {
          other_user = create(:user)
          login(other_user)
        }

        it "doesn't update question" do
          patch :update, params: { id: question, question: attributes_for(:question, body: "corrections") }
          expect(question.reload.body).to eq(question.body)
        end

        it "redirects to show question" do
          patch :update, params: { id: question, question: attributes_for(:question, body: "corrections") }
          expect(response).to redirect_to question_path(question)
        end                
      end

      context "being an author of question" do
        before { login(user) }

        context 'with invalid params' do
          it "keeps unchanged" do
            patch :update, params: { id: question, question: attributes_for(:question, body: "") }
            expect(question.reload.body).to eq(question.body)
          end
         
          it "renders edit template" do
            patch :update, params: { id: question, question: attributes_for(:question, body: "") }
            expect(response).to render_template(:edit)
          end
        end

        context 'with valid params' do
          it "updates question in db" do
            patch :update, params: { id: question, question: attributes_for(:question, body: "corrections") }
            expect(question.reload.body).to eq("corrections")
          end

          it "renders show template" do 
            patch :update, params: { id: question, question: attributes_for(:question, body: "corrections") }
            expect(response).to redirect_to(controller.question)
          end
        end
      end
    end
  end

# edit-update / END

  describe "DELETE destroy" do

    context "when unauthorized" do
      it "doesn't delete question" do
        question
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(0)
      end

      it "renders question show template" do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to new_user_session_path
      end   
    end

    context "when authorized" do
      context "being not an author of question" do
        before {
          other_user = create(:user)
          login(other_user)
        }

        it "doesn't delete question" do
          question
          expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(0)
        end

        it "renders question show template" do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to question_path(question)
        end        
      end

      context "being an author of question" do
        before { login(user) }

        it "deletes question from db" do
          question
          expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
        end

        it "deletes all question's answers from db" do
          answers = create_list(:answer, 5, question: question)
          expect { delete :destroy, params: { id: question } }.to change(question.answers, :count).by(-5)
        end

        it "renders questions index template" do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end      
    end
  end
end