require "rails_helper"

feature 'User can choose best answer', %q{
  In order to give an attention of its correctness if full list
} do

  given(:user)         { create(:user) }
  given(:question)     { create(:question, author: user) }
  given!(:answers)     { create_list(:answer, 5, question: question, author: user) }
  given(:best_answer)  { create(:answer, question: question) }
  given(:other_user)   { create(:user) }

  feature "being unauthorized" do
    scenario "tries to mark best answer" do
      visit question_path(question)
      expect(page).to have_no_button("Mark best")
    end
  end

  feature "being authorized", js: true do
    background {
      answers
      best_answer
    }
    
    scenario "tries to mark best answer of other's question" do
      sign_in(other_user)
      visit question_path(question)
      expect(page).to have_no_button("Mark best")
    end

    scenario "marks best answer" do
      sign_in(user)
      visit question_path(question)
      page.first("table.answers > tbody > tr", text: best_answer.body).click_button("Mark best")
      sleep(1)
      expect(page.first("table.answers > tbody > tr")).to have_content(best_answer.body)
    end
  end
end