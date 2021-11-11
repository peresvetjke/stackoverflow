require "rails_helper"

feature 'User can view question', %q{
  In order to check it or look through answers
} do

  given(:user)     { create(:user) }
  given(:question) { create(:question) }

  background { sign_in(user) }

  scenario "views question and see its title and body" do
    visit question_path(question)
    expect(page).to satisfy("has title and body") { |page| page.has_content?(question.title) && page.has_content?(question.body) }
  end

  scenario "views question without answers" do
    visit question_path(question)
    expect(page.all('li.answer').count).to eq(0)
  end
  
  scenario "views question with answers" do
    other_question = create(:question)
    other_answers = create_list(:answer, 5, question: other_question)
    answers = create_list(:answer, 5, question: question)
    visit question_path(question)
    expect(page).to satisfy("has all & only question's answers") do |page| 
      page.all('li.answer').count == 5 && 
      answers.all? { |a| page.has_content?(a.body) } 
    end
  end
end