require "rails_helper"

RSpec.describe QuestionsController, :type => :controller do

  let (:user)         { create(:user) }
  let (:question)     { create(:question, author: user) }
  let(:authenticable) { question }

  describe "GET index" do
    let(:questions) { create_list(:question, 5) }
    subject { get :index }
    
    include_examples "it_renders", :index

    it "assigns the all questions to @questions" do
      subject
      expect(assigns(:questions)).to match_array(questions)
    end
  end

  describe "GET show" do
    before { get :show, params: { id: question } }
    
    include_examples "it_renders", :show

    it "assigns the requested question to @question" do
      expect(assigns(:question)).to eq question
    end

    it "assigns the answers of requested question to @answers" do
      expect(assigns(:answers)).to eq question.answers
    end

    it "assigns the comments of requested question to @comments" do
      expect(assigns(:comments)).to eq question.comments
    end
  end

  describe "GET new" do
    subject { get :new }

    it_behaves_like "Authenticable", :html

    context "being authenticated" do
      before { login(user) }

    include_examples "it_renders", :new
    end
  end

  describe "POST create" do    
    subject { post :create, params: {question: attributes_for(:question)} }

    it_behaves_like "Authenticable", :html

    context "being authenticated" do
      before { login(create(:user)) }

      context 'with invalid params' do
        subject { post :create, params: {question: attributes_for(:question, :invalid)} }

        it "keeps count unchanged" do
          expect{subject}.not_to change(Question, :count)
        end
        
        include_examples "it_renders", :new
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

    it_behaves_like "Authenticable", :html

    shared_examples 'not an author of question' do
      it "assigns the requested question to @question" do
        subject  
        expect(assigns(:question)).to eq question
      end

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

        include_examples "it_renders", :edit
    end

    context "being not an author of question" do
      before { login(create(:user)) }
      it_behaves_like 'not an author of question'
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
    subject { patch :update, params: { id: question, question: attributes_for(:question, body: "corrections") } }

    it_behaves_like "Authenticable", :html

    shared_examples 'not an author of question' do
      before { subject }
      
      it "assigns the requested question to @question" do
        expect(assigns(:question)).to eq(question)
      end

      it "doesn't update question in db" do
        expect(question.reload.body).to eq(question.body)
      end

      it "rendirects to root path" do
        expect(response).to redirect_to(root_path)
      end
    end

    shared_examples 'author of question' do
      context 'with invalid params' do
        subject { patch :update, params: {id: question, question: attributes_for(:question, :invalid)} }
        
        it "assigns the requested question to @question" do
          subject
          expect(assigns(:question)).to eq(question)
        end

        it "keeps unchanged" do
          subject
          expect(question.reload.body).to eq(question.body)
        end
       
        include_examples "it_renders", :edit
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

    context "being not an author of question" do
      before { login(create(:user)) }
      it_behaves_like 'not an author of question'
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

    it_behaves_like "Authenticable", :html

    shared_examples 'not author of question' do
      it "assigns the requested question to @question" do
        subject
        expect(assigns(:question)).to eq question
      end

      it "doesn't delete question" do
        question
        expect{subject}.not_to change(Question, :count)
      end

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

      it "deletes question from db" do
        question
        expect{subject}.to change(Question, :count).by(-1)
      end

      it "renders questions index template" do
        subject
        expect(response).to redirect_to questions_path
      end
    end

    context "being not an author of question" do
      before { login(create(:user)) }
      it_behaves_like 'not author of question'
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

  describe "POST subscribe" do
    subject { post :subscribe, params: {id: question}, format: :js }

    context "being a guest" do
      include_examples "it_returns_status", 401      
    end

    context "being authenticated" do
      let(:follower) { create(:user) }
      
      before { login(follower) }

      include_examples "it_renders", :subscribe

      context "not subscribed" do
        it "creates subscription" do
          expect { subject } .to change(Subscription, :count).by(1)
        end
      end
      
      context "subscribed" do
        let!(:subscription) { create(:subscription, question: question, user: follower) }

        it "destroys subscription" do
          expect { subject } .to change(Subscription, :count).by(-1)
        end
      end
    end
  end
end