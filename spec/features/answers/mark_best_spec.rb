require "rails_helper"

feature 'User can choose best answer', %q{
  In order to give an attention of its correctness if full list
} do

  given(:user)         { create(:user) }
  given(:awarding)     { build(:awarding) }
  given(:question)     { create(:question, awarding: awarding, author: user) }
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

    feature "marks best answer" do
      scenario "moves the best answer on top" do
        sign_in(user)
        visit question_path(question)
        page.first("table.answers > tbody > tr", text: best_answer.body).click_button("Mark best")
        sleep(1)
        expect(page.first("table.answers > tbody > tr")).to have_content(best_answer.body)
      end

      scenario "grants achievement to the best answer author" do
        sign_in(user)
        visit question_path(question)
        page.first("table.answers > tbody > tr", text: best_answer.body).click_button("Mark best")
        sign_out
        sign_in(best_answer.author)
        visit awardings_path
        expect(page).to have_content(awarding.title)
      end
    end
  end
end