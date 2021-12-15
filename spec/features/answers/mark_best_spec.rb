require "rails_helper"

feature 'User can choose best answer', %q{
  In order to give an attention of its correctness if full list
} do

  given!(:user)         { create(:user) }
  given!(:awarding)     { build(:awarding) }
  given!(:question)     { create(:question, awarding: awarding, author: user) }
  given!(:answers)     { create_list(:answer, 5, question: question, author: user) }
  given!(:best_answer)  { create(:answer, question: question) }

  shared_examples "guest" do
    scenario "tries to mark best answer", js: true do
      visit question_path(question)
      expect(page).to have_no_button("Mark best")
    end
  end

  shared_examples "author of question", js: true do
    feature "marks best answer" do
      scenario "moves the best answer on top" do
        visit question_path(question)
        page.first("table.answers > tbody > tr", text: best_answer.body).click_button("Mark best")
        sleep(1)
        expect(page.first("table.answers > tbody > tr")).to have_content(best_answer.body)
      end
    end
  end

  feature "being a guest" do
    it_behaves_like "guest"
  end

  feature "being not a author of question" do
    background { sign_in(create(:user)) }
    it_behaves_like "guest"
  end

  feature "being a author of question" do
    background { sign_in(user) }
    it_behaves_like "author of question"
  end

  feature "being an admin" do
    background { sign_in(create(:user, admin: true)) }
    it_behaves_like "author of question"
  end
    
  feature "awardings", js: true do
    background do
      sign_in(user)
      visit question_path(question)
      page.first("table.answers > tbody > tr", text: best_answer.body).click_button("Mark best")
      sign_out
    end

    it "grants awarding to best answer's author" do
      sign_in(best_answer.author)
      visit awardings_path
      expect(page).to have_content(awarding.title)
    end
  end
end