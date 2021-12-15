require "rails_helper"

RSpec.describe AnswersController, :type => :controller do
  
  let(:user)     { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer)   { create(:answer, author: user, question: question) }

  describe "GET edit" do
    subject { get :edit, params: {id: answer} }

    it "assigns the answer to @answer" do
      subject
      expect(assigns(:answer)).to eq answer
    end

    shared_examples "guest" do
      it "redirect to root path" do
        subject    
        expect(response).to redirect_to root_path
      end
    end

    shared_examples "author of answer" do
      it "renders edit template" do
        subject
        expect(response).to render_template(:edit)
      end
    end

    context "being a guest" do
      it_behaves_like 'guest'      
    end

    context "being not an author" do
      before { login(create(:user)) }
      it_behaves_like 'guest'      
    end

    context "being an author of answer" do
      before { login(user) }
      it_behaves_like 'author of answer'
    end

    context 'being an admin' do
      before { login(create(:user, admin:true)) }
      it_behaves_like 'author of answer'
    end
  end

  describe "POST create" do
    it "assigns the question to @question" do
      post :create, params: {answer: attributes_for(:answer), question_id: question, format: :js}
      expect(assigns(:question)).to eq question
    end

    shared_examples "guest" do
      subject { post :create, params: {answer: attributes_for(:answer), question_id: question, format: :js} }

      it "keeps count unchanged" do
        expect{ subject }.not_to change(Answer, :count)
      end

      it "redirects to root path" do
        subject
        expect(response).to redirect_to root_path
      end
    end

    shared_examples "authenticated" do
      subject { post :create, params: {answer: attributes_for(:answer, :invalid), question_id: question, format: :js} }

      context 'with invalid params' do
        it "keeps count unchanged" do
          expect{ subject }.not_to change(question.answers, :count)
        end
        it "renders create" do
          subject
          expect(response).to render_template :create
        end
      end

      context 'with valid params' do
        subject {post :create, params: { answer: attributes_for(:answer), question_id: question, author_id: user }, format: :js}

        it "creates new answer in db" do
          expect{subject}.to change(question.answers, :count).by(1)
        end       
        it "renders create" do
          subject
          expect(response).to render_template :create
        end
      end
    end

    context "being a guest" do
      it_behaves_like 'guest'
    end

    context "being authenticated" do
      before { login(user) }
      it_behaves_like 'authenticated'
    end

    context 'being an admin' do
      before { login(create(:user, admin:true)) }
      it_behaves_like 'authenticated'
    end
  end

  describe "PATCH update" do
    it "assigns the answer to @answer" do
      patch :update, params: { id: answer, answer: attributes_for(:answer, body: "corrections")}
      expect(assigns(:answer)).to eq answer
    end

    shared_examples 'guest' do
      subject {patch :update, params: { id: answer, answer: attributes_for(:answer, body: "corrections")} }
      it "doesn't update record" do
        subject
        expect(answer.reload.body).to eq(answer.body)
      end

      it "redirects to root path" do
        subject
        expect(response).to redirect_to root_path
      end
    end

    shared_examples "author of answer" do
      context 'with invalid params' do
        subject { patch :update, params: { id: answer, answer: attributes_for(:answer, body: "") } }
        
        it "doesn't update record" do
          subject
          expect(answer.reload.body).to eq(answer.body)
        end
       
        it "returns :ok status" do
          subject
          expect(response).to have_http_status(200)
        end
      end

      context 'with valid params' do
        subject { patch :update, params: {id: answer, answer: attributes_for(:answer, body: "corrections")} }
        
        it "updates question in db" do
          subject
          expect(answer.reload.body).to eq("corrections")
        end

        it "renders show template" do 
          subject
          expect(response).to redirect_to(answer.question)
        end
      end

      context "with new file attached" do
        it "creates attachment in db" do
          expect{ patch :update, params: { id: answer, answer: attributes_for(:answer, files: [Rack::Test::UploadedFile.new('spec/support/image.jpeg', 'image/jpeg')]) } }
            .to change(ActiveStorage::Attachment, :count).by(1)
        end   
      end
    end

    context "being not an author of answer" do
      before { login(create(:user)) }
      it_behaves_like 'guest'
    end

    context "being an author of answer" do
      before { login(user) }
      it_behaves_like 'author of answer'
    end

    context 'being an admin' do
      before { login(create(:user, admin:true)) }
      it_behaves_like 'author of answer'
    end
  end

  describe "POST mark_best" do    
    subject { post :mark_best, params: {id: answer}, format: :js }

    it "assigns the answer to @answer" do
      subject
      expect(assigns(:answer)).to eq answer
    end

    shared_examples 'guest' do
      it "keeps unchanged" do
        subject
        expect(question.answers.select {|q| q.best }.count).to eq(0)
      end
    end

    shared_examples 'author of question' do
      it "marks as best" do
        subject
        expect(answer.reload.best).to be true
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
    
    context 'being an admin' do
      before { login(create(:user, admin: true)) }
      it_behaves_like 'author of question'
    end
  end

  describe "DELETE destroy" do    
    subject { delete :destroy, params: {id: answer}, format: :js }
    
    it "assigns the answer to @answer" do
      subject
      expect(assigns(:answer)).to eq answer
    end

    shared_examples 'guest' do
      it "doesn't delete answer" do
        answer
        expect{subject}.not_to change(Answer, :count)
      end

      it "redirects to root path" do
        subject
        expect(response).to redirect_to root_path
      end
    end

    shared_examples 'author of answer' do
      it "deletes question from db" do
        answer
        expect{subject}.to change(Answer, :count).by(-1)
      end
    end

    context 'being a guest' do
      it_behaves_like 'guest'
    end

    context "being not an author of question" do
      before { login(create(:user)) }
      it_behaves_like 'guest'
    end
    
    context 'being an author of answer' do
      before { login(user) }
      it_behaves_like 'author of answer'
    end

    context 'being an admin' do
      before { login(create(:user, admin: true)) }
      it_behaves_like 'author of answer'
    end    
  end
end