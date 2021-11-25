require "rails_helper"

feature 'User can view question', %q{
  In order to check it or look through answers
} do

  given(:user)           { create(:user) }
  given(:question)       { create(:question) }
  given(:answers)        { create_list(:answer, 5, question: question) }
  given(:other_question) { create(:question) }
  given(:other_answers)  { create_list(:answer, 5, question: other_question) }
  background { sign_in(user) }

  scenario "views question and see its title and body" do
    visit question_path(question)
    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)
  end

  scenario "views question without answers" do
    visit question_path(question)
    expect(page.all('.answers tbody table').count).to eq(0)
  end
  
  scenario "views question with answers" do
    answers
    other_answers
    visit question_path(question)
    expect(page).to satisfy("has all & only question's answers") do |page| 
      page.all('.answers tbody table').count == answers.count && 
      answers.all? { |a| page.has_content?(a.body) } 
    end
  end
end