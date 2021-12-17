require "rails_helper"

RSpec.describe ActiveStorage::AttachmentsController, :type => :controller do

  shared_examples 'attached' do  
    describe "DELETE delete_attachment" do
      let (:user)     { create(:user) }
      before  { attachable.files.attach(create_file_blob) }
      subject { delete :destroy, params: {id: attachable.files.first.id}, format: :js }

      shared_examples 'guest' do
        it "doesn't delete attachment" do
          expect{subject}.not_to change(ActiveStorage::Attachment, :count)
        end

        it "returns unauthorized status" do
          subject
          expect(response).to have_http_status 401
        end
      end

      shared_examples 'not an author of attachable' do
        it "doesn't delete attachment" do
          expect{subject}.not_to change(ActiveStorage::Attachment, :count)
        end

        it "returns forbidden status" do
          subject
          expect(response).to have_http_status 403
        end
      end

      shared_examples 'author of attachable' do
        it "deletes attachment from db" do
          expect{subject}.to change(attachable.files, :count).by(-1)
        end

        it "renders questions destroy template" do
          subject
          expect(response).to render_template(:destroy)
        end
      end

      context 'being a guest' do
        it_behaves_like 'guest'
      end

      context 'being not an author of attachable' do
        before { login(create(:user)) }

        it_behaves_like 'not an author of attachable'
      end

      context 'being an author of attachable' do
        before { login(user) }

        it_behaves_like 'author of attachable'
      end

      context 'being an admin' do
        before { login(create(:user, admin: true)) }

        it_behaves_like 'author of attachable'
      end
    end
  end

  context 'deleting attachments of question' do
    it_behaves_like 'attached' do 
      let!(:attachable) { create(:question, author: user) }
    end
  end

  context 'deleting attachments of answer' do
    it_behaves_like 'attached' do 
      let!(:attachable) { create(:answer, question: create(:question), author: user) }
    end
  end  
end