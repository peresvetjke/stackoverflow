require "rails_helper"

feature 'User can destroy comment', %q{
  In order to delete it completely
} do

  given!(:user)     { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer)   { create(:answer, question: question, author: user) }

  shared_examples "commentable", js: true do
    shared_examples "guest" do
      scenario "tries to delete answer" do
      visit question_path(question)
      expect(find(".comment", text: comment.body)).to have_no_link("Delete")
      end
    end

    shared_examples "author of comment" do
      scenario "deletes answer" do
        visit question_path(question)
        within(".comment", text: comment.body) do
          accept_alert { click_link("Delete") }
        end
        accept_alert
        expect(page).to have_no_content(comment.body)
      end
    end

    feature "being guest" do
      it_behaves_like "guest"
    end

    feature "being not an author" do
      background { sign_in(create(:user)) }
      it_behaves_like "guest"
    end

    feature "being an author" do
      background { sign_in(user) }
      it_behaves_like "author of comment"
    end

    feature "being an admin" do
      background { sign_in(create(:user, admin: true)) }
      it_behaves_like "author of comment"
    end
  end

  feature "commenting question" do
    it_behaves_like 'commentable' do
      given!(:comment) { create(:comment, commentable: question, author: user)}
    end
  end

  feature "commenting answer" do
    it_behaves_like 'commentable' do
      given!(:comment) { create(:comment, commentable: answer, author: user)}
    end
  end
end