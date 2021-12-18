require "rails_helper"

feature 'User can destroy question', %q{
  In order to delete it completely
} do

  given(:user)     { create(:user) }
  given(:question) { create(:question, author: user) }

  shared_examples "guest" do
    scenario "tries to delete question" do
      visit question_path(question)
      expect(page).to have_no_button("Delete Question")
    end
  end

  shared_examples "author of question" do
    scenario "deletes own question" do
      visit question_path(question)
      click_button "Delete Question"
      expect(page).to have_content("Question was successfully destroyed")
      expect(page).to have_no_content(question.title)
    end
  end

  feature "being a guest" do
    it_behaves_like "guest"
  end

  feature "being not an author of question" do
    before { sign_in(create(:user)) }
    it_behaves_like "guest"
  end

  feature "being an author of question" do
    before { sign_in(user) }
    it_behaves_like "author of question"
  end
  
  feature "being an admin" do
    before { sign_in(create(:user, admin: true)) }
    it_behaves_like "author of question"
  end
end