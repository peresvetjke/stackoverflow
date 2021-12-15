require "rails_helper"

RSpec.describe QuestionsController, :type => :controller do

  let (:user)         { create(:user) }
  let (:question)     { create(:question, author: user) }

  describe "GET index" do
    let(:questions) { create_list(:question, 5) }
    subject { get :index }
    
    it "renders index template" do
      subject
      expect(response).to render_template(:index)
    end

    it "assigns the all questions to @questions" do
      subject
      expect(assigns(:questions)).to match_array(questions)
    end
  end

  describe "GET show" do
    subject { get :show, params: { id: question } }
    
    it "renders show template" do
      subject
      expect(response).to render_template(:show)
    end

    it "assigns the requested question to @question" do
      subject
      expect(assigns(:question)).to eq question
    end

    it "assigns the answers of requested question to @answers" do
      subject
      expect(assigns(:answers)).to eq question.answers
    end

    it "assigns the comments of requested question to @comments" do
      subject
      expect(assigns(:comments)).to eq question.comments
    end
  end

  describe "GET new" do
    subject { get :new }

    context "being a guest" do
      it "redirects to root path" do
        subject
        expect(response).to redirect_to root_path
      end
    end

    context "being authenticated" do
      before { login(user) }

      it "renders new template" do
        subject
        expect(response).to render_template(:new)
      end
    end
  end

  describe "POST create" do    
    subject { post :create, params: {question: attributes_for(:question)} }

    context "being a guest" do
      it "keeps count unchanged" do
        expect{subject}.to change(Question, :count).by(0)
      end

      it "redirects to root path" do
        subject
        expect(response).to redirect_to root_path
      end
    end

    context "being authenticated" do
      before { login(create(:user)) }

      context 'with invalid params' do
        subject { post :create, params: {question: attributes_for(:question, :invalid)} }

        it "keeps count unchanged" do
          expect{subject}.to change(Question, :count).by(0)
        end
       
        it "renders new template" do
          subject
          expect(response).to render_template :new
        end
      end

      context 'with valid params' do
        subject { post :create, params: {question: attributes_for(:question)} }
        
        it "creates new question in db" do
          expect{subject}.to change(Question, :count).by(1)
        end

        it "redirects show template" do 
          subject
          expect(response).to redirect_to Question.last
        end
      end
    end
  end

  describe "GET edit" do
    subject { get :edit, params: {id: question} }

    shared_examples 'guest' do
      it "redirects to root path" do
        subject
        expect(response).to redirect_to root_path
      end
    end

    shared_examples 'author of question' do
      it "assigns the requested question to @question" do
        subject  
        expect(assigns(:question)).to eq question
      end

      it "renders edit template" do
        subject
        expect(response).to render_template(:edit)
      end
    end

    context "being a guest" do
      it_behaves_like 'guest'
    end

    context "being not an author of question" do
      before { login(create(:user)) }
      it_behaves_like 'guest'
    end
    
    context "being an author of question" do
      before { login(user) }
      it_behaves_like 'author of question'
    end

    context "being an admin" do
      before { login(create(:user, admin: true)) }
      it_behaves_like 'author of question'
    end
  end

  describe "PATCH update" do    
    it "assigns the requested question to @question" do
      patch :update, params: {id: question, question: attributes_for(:question, body: "corrections")}
      expect(assigns(:question)).to eq(question)
    end

    shared_examples 'guest' do
      subject { patch :update, params: {id: question, question: attributes_for(:question, body: "corrections")} }

      it "keeps unchanged" do
        subject
        question.reload
        expect(question.body).to eq(question.body)
      end

      it "redirects to root path" do 
        subject
        expect(response).to redirect_to root_path
      end
    end

    shared_examples 'author of question' do
      context 'with invalid params' do
        subject { patch :update, params: {id: question, question: attributes_for(:question, body: "")} }
        
        it "keeps unchanged" do
          subject
          expect(question.reload.body).to eq(question.body)
        end
       
        it "renders edit template" do
          subject
          expect(response).to render_template(:edit)
        end
      end

      context 'with valid params' do
        subject { patch :update, params: { id: question, question: attributes_for(:question, body: "corrections") } }
        
        it "updates question in db" do
          subject
          expect(question.reload.body).to eq("corrections")
        end

        it "renders show template" do 
          subject
          expect(response).to redirect_to(assigns(question))
        end
      end

      context "with new file attached" do
        it "creates attachment in db" do
          expect{ patch :update, params: { id: question, question: attributes_for(:question, files: [Rack::Test::UploadedFile.new('spec/support/image.jpeg', 'image/jpeg')]) } }
            .to change(ActiveStorage::Attachment, :count).by(1)
        end    
      end
    end

    context "being a guest" do
      it_behaves_like 'guest'
    end

    context "being not an author of question" do
      before { login(create(:user)) }
      it_behaves_like 'guest'
    end

    context "being an author of question" do
      before { login(user) }
      it_behaves_like 'author of question'  
    end

    context "being an admin" do
      before { login(create(:user, admin: true)) }
      it_behaves_like 'author of question'
    end
  end

  describe "DELETE destroy" do
    subject { delete :destroy, params: {id: question} }

    it "assigns the requested question to @question" do
      subject
      expect(assigns(:question)).to eq question
    end

    shared_examples 'guest' do  
      it "doesn't delete question" do
        question
        expect{subject}.to change(Question, :count).by(0)
      end

      it "redirect to root path" do
        subject
        expect(response).to redirect_to root_path
      end   
    end

    shared_examples 'author of question' do
      it "deletes question from db" do
        question
        expect{subject}.to change(Question, :count).by(-1)
      end

      it "renders questions index template" do
        subject
        expect(response).to redirect_to questions_path
      end
    end

    context "being a guest" do
      it_behaves_like 'guest'
    end

    context "being not an author of question" do
      before { login(create(:user)) }
      it_behaves_like 'guest'
    end

    context "being an author of question" do
      before { login(user) }
      it_behaves_like 'author of question'
    end    

    context "being an admin" do
      before { login(create(:user, admin: true))}
      it_behaves_like 'author of question'
    end
  end
end