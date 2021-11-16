require "rails_helper"

feature 'User can edit a question', %q{
  In order to correct or update it
} do

  given(:user)     { create(:user) }
  given(:question) { create(:question, author: user) }

  feature "being unauthorized" do
    scenario "tries to edit question" do
      visit question_path(question)
      expect(page).to have_no_button("Edit question")
    end
  end

  feature "being authorized" do
    background { 
      sign_in(user)
      visit question_path(question)
      click_button "Edit question"
    }

    scenario "tries to create question with blank title" do
      fill_in "Title", :with => ""
      fill_in "Body", :with => question.body
      click_button "Save"
      expect(page).to have_text("Title can't be blank")
    end

    scenario "edits question" do
      fill_in "Title", :with => question.title
      fill_in "Body", :with => question.body + " corrections"
      click_button "Save"
      expect(page).to have_text("Question has been successfully updated")
      expect(page).to have_content(question.body + " corrections")
    end
  end
end