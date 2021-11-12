require "rails_helper"

RSpec.describe QuestionsController, :type => :controller do


  describe "GET show" do
    let (:question) { create(:question) }
    
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
      before {
        user = create(:user)
        login(user)
      }

      it "renders new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST create" do    
    context "when unauthorized" do
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
end