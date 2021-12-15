require "rails_helper"

RSpec.describe ActiveStorage::AttachmentsController, :type => :controller do
  
  describe "DELETE delete_attachment" do
    let (:user)     { create(:user) }
    let (:question) { create(:question, author: user) }

    before  { question.files.attach(create_file_blob) }
    subject { delete :destroy, params: {id: question.files.first.id}, format: :js }

    shared_examples 'guest' do
      it "doesn't delete attachment" do
        expect{subject}.not_to change(ActiveStorage::Attachment, :count)
      end

      it "redirects to root path" do
        subject
        expect(response).to redirect_to root_path
      end
    end

    shared_examples 'author of attachable' do
      it "deletes attachment from db" do
        expect{subject}.to change(question.files, :count).by(-1)
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

      it_behaves_like 'guest'
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