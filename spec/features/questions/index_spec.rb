require "rails_helper"

feature 'User can index all questions list', %q{
  In order to find the one he interested in
} do

  given(:user){ create(:user) }

  background { sign_in(user) }

  scenario "without questions" do
    visit questions_path
    expect(page).to have_text("No questions yet")
  end

  scenario "with few questions" do
    questions = create_list(:question, 5)
    visit questions_path
    expect(page).to satisfy("has all questions") { |page| page.all('tr.question').count == 5 && questions.all? { |q| page.has_content?(q.title) } }
  end
end