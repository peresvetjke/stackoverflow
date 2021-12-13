require "rails_helper"

feature 'User can vote for an answer', %q{
  In order to give an attention of its correctness in full list
} do

  given(:user)           { create(:user) }
  given(:question)       { create(:question, author: user) }
  given(:other_user)     { create(:user) }
  given(:other_question) { create(:question, author: other_user) }

  feature "when unauthorized", js: true do
    scenario "tries to vote for a question" do
      visit question_path(question)
      within(".question .vote .up") { click_button }
      expect(page).to have_text('You are not authorized')
    end
  end

  feature "vote for a question", js: true do
    feature "tries to vote for own record" do
      background { 
        sign_in(user)
        visit question_path(question)
      }

      scenario "doesn't change rating" do
        within(".question .vote .up") { click_button }
        accept_alert { }
        expect(page.find('.question .vote .rating')).to have_text("0")
      end
    end

    feature "vote for other's answer" do
      background { 
        sign_in(user)
        visit question_path(other_question)
      }

      scenario "gets rating up" do
        within(".question .vote .up") { click_button }
        expect(page.find('.question .vote .rating')).to have_text("1")
      end

      scenario "gets rating down" do
        within(".question .vote .down") { click_button }
        expect(page.find('.question .vote .rating')).to have_text("-1")
      end
    end
  end
end