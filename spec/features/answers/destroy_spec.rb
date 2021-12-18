require "rails_helper"

feature 'User can destroy answer', %q{
  In order to delete it completely
} do

  given!(:user)         { create(:user) }
  given!(:question)     { create(:question, author: user) }
  given!(:answer)       { create(:answer, author: user, question: question) }
  #given(:other_user)   { create(:user) }
  #given(:other_answer) { create(:answer, question: question, author: other_user) }

  shared_examples "guest", js: true do
    scenario "tries to delete answer" do
      visit question_path(question)
      expect(page).to have_no_button("Delete")
    end
  end

  shared_examples "author of answer", js: true do
    scenario "deletes own answer" do
      visit question_path(question)
      within(".answers table", text: answer.body) do
        accept_alert { click_button("Delete") }
      end
      expect(page).to have_no_content(answer.body)
    end
  end

  feature "being a guest" do
    it_behaves_like "guest"
  end

  feature "being not an author of answer" do
    background { sign_in(create(:user)) }
    it_behaves_like "guest"
  end

  feature "being an author of answer" do
    background { sign_in(user) }
    it_behaves_like "author of answer"
  end

  feature "being an admin" do
    background { sign_in(create(:user, admin: true)) }
    it_behaves_like "author of answer"
  end
end