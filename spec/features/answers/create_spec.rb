require "rails_helper"

feature 'User can post answer', %q{
  In order to provide others with solution
} do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }
  
  background {
    sign_in(user)
    }

  scenario "tries to create answer with blank body" do
    visit question_path(question)
    fill_in "Your answer", :with => ""
    click_button "Create Answer"
    expect(page).to have_text("Body can't be blank")
  end

  scenario "tries to create answer with non-unique body" do
    answer = create(:answer, question: question)

    visit question_path(question)
    fill_in "Your answer", :with => answer.body
    click_button "Create Answer"
    expect(page).to have_text("Body already exists for question")
  end

  scenario "tries to create answer" do
    visit question_path(question)
    fill_in "Your answer", :with => "My answer"
    click_button "Create Answer"
    expect(page).to have_text("Answer has been succesfully posted")
  end
end