require "rails_helper"

feature 'User can create a question', %q{
  In order to get an advice with answers
} do

  feature "being unauthorized" do
    scenario "tries to create question" do
      visit questions_path
      click_button "Ask question"
      expect(page).to have_content("You need to sign in or sign up before continuing")
    end    
  end

  feature "being authorized" do
    given(:user)     { create(:user) }
    given(:question) { build(:question) }

    background { 
      sign_in(user)
      visit questions_path
      click_button "Ask question"
    }

    scenario "tries to create question with blank title" do
      fill_in "Title", :with => ""
      fill_in "Body", :with => question.body
      click_button "Create"
      expect(page).to have_text("Title can't be blank")
    end

    scenario "creates question" do
      fill_in "Title", :with => question.title
      fill_in "Body", :with => question.body
      click_button "Create"
      expect(page).to have_text("Question has been successfully created")
      expect(page).to have_content(question.title)
    end
  end
end