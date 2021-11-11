require "rails_helper"

feature 'User can create a question', %q{
  In order to get an advice with answers
} do

  #feature "being unauthorized" do
  #
  #end

  given(:user) { create(:user) }
  background { 
    sign_in(user)
    visit new_question_path 
  }

  #feature "being authorized" do
    scenario "tries to create question with blank title" do
      fill_in "Title", :with => ""
      fill_in "Body", :with => "Body"
      click_button "Create"

      expect(page).to have_text("Title can't be blank")
    end

    scenario "tries to create question with blank body" do
      fill_in "Title", :with => "Title"
      fill_in "Body", :with => ""
      click_button "Create"

      expect(page).to have_text("Body can't be blank")
    end
    
    scenario "creates question" do
      fill_in "Title", :with => "Title"
      fill_in "Body", :with => "Body"
      click_button "Create"

      expect(page).to have_text("Question has been successfully created")
    end
 # end
end