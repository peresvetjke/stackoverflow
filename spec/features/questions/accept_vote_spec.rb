require "rails_helper"

feature 'User can vote for an answer', %q{
  In order to give an attention of its correctness in full list
} do

  given(:user)           { create(:user) }
  given!(:question)       { create(:question, author: user) }

  shared_examples "guest", js: true do
    before { visit question_path(question) }

    scenario "doesn't allow to vote" do
      find(".question .vote .up .accept_vote").click
      expect(accept_confirm{}).to eq "You need to sign in or sign up before continuing."
    end
  end

  shared_examples "author of votable", js: true do
    before { visit question_path(question) }

    scenario "doesn't allow to vote" do
      find(".question .vote .up .accept_vote").click
      expect(accept_confirm{}).to eq "Sorry, can't vote for your own record."
    end
  end

  shared_examples "not an author of question", js: true do
    before { visit question_path(question) }

    scenario "gets rating up" do
      find(".question .vote .up .accept_vote").click
      expect(page.find('.question .vote .rating')).to have_text("1")
    end

    scenario "gets rating down" do
      find(".question .vote .down .accept_vote").click
      expect(page.find('.question .vote .rating')).to have_text("-1")
    end
  end

  feature "being a guest" do
    it_behaves_like "guest"
  end

  feature "being an author of question" do
    before { sign_in(user) }
    it_behaves_like "author of votable"
  end

  feature "being not an author of question" do
    before { sign_in(create(:user)) }
    it_behaves_like "not an author of question"
  end

  feature "being an admin" do
    before { sign_in(create(:user, admin: true)) }
    it_behaves_like "not an author of question"
  end
end