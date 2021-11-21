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
    background {sign_in(user)}

    scenario "tries to create answer with blank body" do
      visit question_path(question)
      fill_in "Your answer", :with => ""
      click_button "Create Answer"
      expect(page).to have_text("Body can't be blank")
    end

    scenario "tries to create answer with non-unique body" do
      visit question_path(question)
      fill_in "Your answer", :with => answer.body
      click_button "Create Answer"
      expect(page).to have_text("Body already exists for question")
    end

    scenario "creates answer" do
      visit question_path(question)
      fill_in "Your answer", :with => new_answer.body
      click_button "Create Answer"
      within(".answers") do
        expect(page).to have_content(new_answer.body)
      end
    end
  end
end