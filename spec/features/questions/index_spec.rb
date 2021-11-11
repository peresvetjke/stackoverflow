require "rails_helper"

feature 'User can index all questions list', %q{
  In order to find the one he interested in
} do

  given(:user){ create(:user) }

  background { 
    Question.destroy_all
    sign_in(user)
    }

  scenario "lists index when no question exists" do
    visit questions_path
    expect(page).to have_text("No questions yet")
  end

  scenario "lists index when 1 question exists" do
    question = create(:question)
    visit questions_path
    expect(page).to have_text(question.title)
  end

  scenario "lists index when few questions exist" do
    question = create_list(:question, 5)
    visit questions_path
    expect(page.all('table tr.question').count).to eq(5)
  end
end