require "rails_helper"

feature 'User can destroy question', %q{
  In order to delete it completely
} do

  given(:user)     { create(:user) }
  given(:question) { create(:question, author: user) }

  feature "being unauthorized" do
    scenario "tries to delete question" do
      visit question_path(question)
      expect(page).to have_no_button("Delete Question")
    end
  end

  feature "being authorized" do
    given(:other_user)     { create(:user) }
    given(:other_question) { create(:question, author: other_user) }
    background { sign_in(user) }

    scenario "tries to delete other's question" do
      visit question_path(other_question)
      expect(page).to have_no_button("Delete Question")
    end

    scenario "deletes own question" do
      visit question_path(question)
      click_button "Delete Question"
      expect(page).to have_content("Your question has been deleted")
      expect(page).to have_no_content(question.title)
    end
  end
end