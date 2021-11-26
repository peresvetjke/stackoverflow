require "rails_helper"

feature 'User can post answer', %q{
  In order to provide others with solution
} do

  given(:question) { create(:question) }

  feature "being unauthorized" do

    scenario "tries to create answer" do
      visit question_path(question)
      expect(page).to have_no_button("Create Answer")
    end
  end

  feature "being authorized", js: true do
    given(:user)       { create(:user) }
    given(:answer)     { create(:answer, question: question) }
    given(:new_answer) { build(:answer)}
    background {
      sign_in(user)
      visit question_path(question)
    }

    scenario "tries to create answer with blank body" do
      fill_in "Your answer", :with => ""
      click_button "Create Answer"
      expect(page).to have_text("Body can't be blank")
    end

    scenario "tries to create answer with non-unique body" do
      fill_in "Your answer", :with => answer.body
      click_button "Create Answer"
      expect(page).to have_text("Body already exists for question")
    end

    scenario "creates answer" do
      fill_in "Your answer", :with => new_answer.body
      click_button "Create Answer"
      within(".answers") do
        expect(page).to have_content(new_answer.body)
      end
    end

    scenario "attaches file" do
      fill_in "Your answer", :with => new_answer.body
      attach_file 'answer_files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]  
      click_button "Create Answer"
      sleep(1)
      within(".answers") do
        expect(page).to have_link('rails_helper.rb')
        expect(page).to have_link('spec_helper.rb')
      end
    end

    scenario "attaches link" do
      fill_in "Your answer", :with => new_answer.body
      within("#links") do  
        click_link "add link"
        fill_in "Title", :with => "Google"
        fill_in "Url", :with => "https://www.google.com/"
      end
      click_button "Create"
      expect(page).to have_link("Google", href: "https://www.google.com/")
    end
  end
end