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

    scenario "attaches file" do
      fill_in "Title", :with => question.title
      fill_in "Body", :with => question.body
      attach_file 'question_files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_button "Create"
      expect(page).to have_link('rails_helper.rb')
      expect(page).to have_link('spec_helper.rb')
    end

    scenario "attaches link", js: true do
      fill_in "Title", :with => question.title
      fill_in "Body", :with => question.body
      within("#links") do  
        click_link "add link"
        fill_in "Title", :with => "Google"
        fill_in "Url", :with => "https://www.google.com/"
      end
      click_button "Create"
      expect(page).to have_link("Google", href: "https://www.google.com/")
    end

    scenario "attaches awarding", js: true do
      fill_in "Title", :with => question.title
      fill_in "Body", :with => question.body
      within("#awarding") do
        click_link "add awarding"
        fill_in "Title", :with => "Altruist"
        attach_file 'Image', "#{Rails.root}/spec/support/image.jpeg"
      end
      click_button "Create"
      expect(page).to have_css("#awarding")
      expect(page).to have_content("Altruist")
    end
  end
end