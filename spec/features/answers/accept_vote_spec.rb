require "rails_helper"

feature 'User can vote for an answer', %q{
  In order to give an attention of its correctness in full list
} do

  given!(:user)         { create(:user) }
  given!(:question)     { create(:question, author: user) }
  given!(:answer)       { create(:answer, question: question, author: user) }

  shared_examples "guest", js: true do
    scenario "tries to vote for an answer" do
      visit question_path(question)
      within(page.first(".answers > tbody > tr .vote .up")) { click_button }
      expect(accept_confirm{}).to eq "You need to sign in or sign up before continuing."
    end
  end

  shared_examples "author of answer", js: true do
    scenario "tries to vote for an answer" do
      visit question_path(question)
      within(page.first(".answers > tbody > tr .vote .up")) { click_button }
      expect(accept_confirm{}).to eq "Sorry, can't vote for your own record."
    end
  end
  
  shared_examples "not an author of answer", js: true do
    feature "vote for other's answer" do
      background { visit question_path(question) }

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

  feature "being guest" do
    it_behaves_like "guest"
  end

  feature "being an author of answer" do
    before { sign_in(user) }
    it_behaves_like "author of answer"
  end

  feature "being not an author of answer" do
    before { sign_in(create(:user)) }
    it_behaves_like "not an author of answer"
  end

  feature "being an admin" do
    before { sign_in(create(:user, admin: true)) }
    it_behaves_like "not an author of answer"
  end
end