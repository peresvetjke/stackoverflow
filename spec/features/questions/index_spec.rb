require "rails_helper"

feature 'User can index all questions list', %q{
  In order to find the one he interested in
} do

  given(:user){ create(:user) }

  background { 
    Question.destroy_all
    sign_in(user)
    }

  scenario "views index when no question exists" do
    visit questions_path
    expect(page).to have_text("No questions yet")
  end

  scenario "views index when 1 question exists" do
    question = create(:question)
    visit questions_path
    expect(page).to have_text(question.title)
  end

  scenario "views index when few questions exist" do
    questions = create_list(:question, 5)
    visit questions_path
    expect(page).to satisfy("has all questions") { |page| page.all('table tr.question').count == 5 && questions.all? { |q| page.has_content?(q.title) } }
  end
end