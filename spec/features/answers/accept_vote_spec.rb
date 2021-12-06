require "rails_helper"

feature 'User can vote for an answer', %q{
  In order to give an attention of its correctness in full list
} do

  given(:user)         { create(:user) }
  given(:question)     { create(:question, author: user) }
  given(:answer)       { create(:answer, question: question, author: user) }
  given(:other_user)   { create(:user) }
  given(:other_answer) { create(:answer, question: question, author: other_user) }

  feature "when unauthorized", js: true do
    scenario "tries to vote for an answer" do
      answer
      visit question_path(question)
      within(page.first(".answers > tbody > tr .vote .up")) { click_button }
      accept_alert { }
      expect(page.first(".answers > tbody > tr .vote .rating")).to have_text("0")
    end
  end

  feature "vote for an answer", js: true do
    feature "tries to vote for own record" do
      background { 
        answer
        sign_in(user)
        visit question_path(question)
      }

      scenario "doesn't change rating" do
        within(page.first(".answers > tbody > tr .vote .up")) { click_button }
        accept_alert { }
        expect(page.first(".answers > tbody > tr .vote .rating")).to have_text("0")
      end
    end

    feature "vote for other's answer" do
      background { 
        other_answer
        sign_in(user)
        visit question_path(question)
      }

      scenario "gets rating up" do
        within(page.first(".answers > tbody > tr .vote .up")) { click_button }
        expect(page.first(".answers > tbody > tr .vote .rating")).to have_text("1")
      end

      scenario "gets rating down" do
        within(page.first(".answers > tbody > tr .vote .down")) { click_button }
        expect(page.first(".answers > tbody > tr .vote .rating")).to have_text("-1")
      end
    end
  end
end