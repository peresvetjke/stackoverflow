require "rails_helper"

RSpec.describe AnswersController, :type => :controller do
  
  let(:user)     { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer)   { create(:answer, author: user, question: question) }

  describe "POST create" do
    context "when unauthenticated" do
      it "returns unauthorized status" do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js} 
        expect(response).to have_http_status(401)
      end 
    end

    context "when authenticated" do
      before { login(user) }

      context 'with invalid params' do
        it "keeps count unchanged" do
          expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js } }.to change(question.answers, :count).by(0)
        end
        it "renders create" do
          post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
          expect(response).to render_template :create
        end
      end

      context 'with valid params' do
        it "creates new answer in db" do
          expect { post :create, params: { answer: attributes_for(:answer), question_id: question, author_id: user }, format: :js}.to change(question.answers, :count).by(1)
        end       
        it "renders create" do
          post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
          expect(response).to render_template :create
        end
      end
    end
  end

  describe "GET edit" do
    context "when unauthenticated" do
      it "redirect to root path" do
        get :edit, params: { id: answer }
        expect(response).to redirect_to root_path
      end      
    end

    context "when authenticated" do
      context "being an author of question" do
        before { login(user) }

        it "renders edit template" do
          get :edit, params: { id: answer }
          expect(response).to render_template(:edit)
        end
      end
    end
  end

  describe "PATCH update" do    
    context "when unauthenticated" do
      it "keeps unchanged" do
        patch :update, params: { id: answer, answer: attributes_for(:answer, body: "corrections") }
        answer.reload
        expect(answer.body).to eq(answer.body)
      end

      it "returns unauthorized status" do
        patch :update, params: { id: answer, answer: attributes_for(:answer, body: "corrections") }
        expect(response).to have_http_status(401)
      end
    end

    context "when authenticated" do
      context "being not an author of answer" do
        before {
          other_user = create(:user)
          login(other_user)
        }

        it "doesn't update answer" do
          patch :update, params: { id: answer, answer: attributes_for(:answer, body: "corrections") }
          expect(answer.reload.body).to eq(answer.body)
        end

        it "redirects to show question" do
          patch :update, params: { id: answer, answer: attributes_for(:answer, body: "corrections") }
          expect(response).to redirect_to(answer.question)
        end                
      end

      context "being an author of answer" do
        before { login(user) }

        context 'with invalid params' do
          it "keeps unchanged" do
            patch :update, params: { id: answer, answer: attributes_for(:answer, body: "") }
            expect(answer.reload.body).to eq(answer.body)
          end
         
          it "renders edit template" do
            patch :update, params: { id: answer, answer: attributes_for(:answer, body: "") }
            expect(response).to render_template(:edit)
          end
        end

        context 'with valid params' do
          it "updates question in db" do
            patch :update, params: { id: answer, answer: attributes_for(:answer, body: "corrections") }
            expect(answer.reload.body).to eq("corrections")
          end

          it "renders show template" do 
            patch :update, params: { id: answer, answer: attributes_for(:answer, body: "corrections") }
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
    end
  end

  describe "POST mark_best" do    
    let(:other_user) { create(:user) }

    context "when unauthorized" do
      it "keeps unchanged" do
        post :mark_best, params: { id: answer }, format: :js
        expect(question.answers.select {|q| q.best }.count).to eq(0)
      end
    end

    context "when authorized" do
      context "being not an author of question" do
        before { login(other_user) }

        it "doesn't update answer" do
          post :mark_best, params: { id: answer }, format: :js
          expect(answer.reload.best).to be false
        end
      end

      context "being an author of question" do
        before { login(user) }

        context 'marks best answer' do
          it "marks as best" do
            post :mark_best, params: { id: answer }, format: :js
            expect(answer.reload.best).to be true
          end
        end
      end
    end
  end

  describe "DELETE destroy" do    
    context "when unauthorized" do
      it "doesn't delete answer" do
        answer
        expect { delete :destroy, params: { id: answer }, format: :js }.not_to change(Answer, :count)
      end

      it "redirects to root path" do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to redirect_to root_path
      end
    end

    context "when authorized" do
      context "being not an author of question" do
        let(:other_user) { create(:user) }
        before { login(other_user) }

        it "doesn't delete question" do
          answer
          expect { delete :destroy, params: { id: answer }, format: :js }.not_to change(Answer, :count)
        end

        it "renders question show template" do
          delete :destroy, params: { id: answer }, format: :js
          expect(response).to redirect_to question_path(question)
        end
      end

      context "being an author of answer" do
        before { login(user) }

        it "deletes question from db" do
          answer
          expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
        end
      end      
    end
  end
end