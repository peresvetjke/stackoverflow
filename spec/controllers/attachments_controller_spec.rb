require "rails_helper"

RSpec.describe ActiveStorage::AttachmentsController, :type => :controller do
  
  describe "DELETE delete_attachment" do
    let (:user)     { create(:user) }
    let (:question) { create(:question, author: user) }

    before { 
      question.files.attach(create_file_blob)
    }

    context "when unauthorized" do
      it "doesn't delete attachment" do
        expect { delete :destroy, params: { id: question.files.first.id }, format: :js }.not_to change(ActiveStorage::Attachment, :count)
      end

      it "redirects to root path" do
        delete :destroy, params: { id: question.files.first.id }, format: :js
        expect(response).to redirect_to root_path
      end   
    end   

    context "when authorized" do
      context "being not an author of question" do
        before {
          other_user = create(:user)
          login(other_user)
        }

        it "doesn't delete attachment" do
          expect {delete :destroy, params: { id: question.files.first.id }, format: :js}.not_to change(question.files, :count)
        end

        it "renders question show template" do
          delete :destroy, params: { id: question.files.first.id }, format: :js
          expect(response).to redirect_to question
        end        
      end

      context "being an author of question" do
        before { login(user) }

        it "deletes attachment from db" do
          expect {delete :destroy, params: { id: question.files.first.id }, format: :js}.to change(question.files, :count).by(-1)
        end

        it "renders questions destroy template" do
          delete :destroy, params: { id: question.files.first.id }, format: :js
          expect(response).to render_template(:destroy)
        end
      end      
    end
  end
end