require "rails_helper"

feature 'User can edit a question', %q{
  In order to correct or update it
} do

  given(:user)     { create(:user) }
  given(:question) { create(:question, author: user) }

  feature "when unauthorized" do
    scenario "tries to edit question" do
      visit question_path(question)
      expect(page).to have_no_button("Edit Question")
    end
  end

  feature "when authorized" do
    feature "being not an author of question" do
      given(:other_user)     { create(:user) }
      background { sign_in(other_user)}

      scenario "tries to edit question" do
        visit question_path(question)
        expect(page).to have_no_button("Edit Question")
      end
    end

    feature "being an author of question" do
      background { 
        sign_in(user)
        visit question_path(question)
        click_button "Edit Question"
      }

      scenario "tries to create question with blank title" do
        fill_in "Title", :with => ""
        fill_in "Body", :with => question.body
        click_button "Update Question"
        expect(page).to have_text("Title can't be blank")
      end

      scenario "edits question" do
        fill_in "Title", :with => question.title
        fill_in "Body", :with => question.body + " corrections"
        click_button "Update Question"
        expect(page).to have_text("Question has been successfully updated")
        expect(page).to have_content(question.body + " corrections")
      end
    end
  end
end