require "rails_helper"

feature 'User can destroy answer', %q{
  In order to delete it completely
} do

  given(:user)         { create(:user) }
  given(:question)     { create(:question, author: user) }
  given(:answer)       { create(:answer, author: user, question: question) }
  given(:other_user)   { create(:user) }
  given(:other_answer) { create(:answer, question: question, author: other_user) }

  feature "being unauthorized" do
    scenario "tries to delete answer" do
      visit question_path(question)
      expect(page).to have_no_button("Delete")
    end
  end

  feature "being authorized", js: true do
    background { sign_in(user) }
    
    scenario "tries to delete other's question" do
      other_answer
      visit question_path(question)
      expect(find(".answers table", text: other_answer.body)).to have_no_button("Delete answer")
    end

    scenario "deletes own answer" do
      answer
      visit question_path(question)
      within(".answers table", text: answer.body) do
        accept_alert { click_button("Delete answer") }
      end
      expect(page).to have_no_content(answer.body)
    end
  end
end