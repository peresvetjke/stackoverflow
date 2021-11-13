require "rails_helper"

feature 'User can destroy answer', %q{
  In order to delete it completely
} do

  given(:user)     { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:answer)   { create(:answer, author: user, question: question) }

  feature "being unauthorized" do
    scenario "tries to delete answer" do
      visit question_path(question)
      expect(page).to have_no_button("Delete")
    end
  end

  feature "being authorized" do
    background { sign_in(user) }
    
    scenario "tries to delete other's question" do
      other_user = create(:user)
      other_answer = create(:answer, question: question, author: other_user)
      visit question_path(question)
      expect(find(:xpath, "//*[contains(text(), '#{other_answer.body}')]/parent::tr")).to have_no_button("Delete answer")
    end

    scenario "deletes own answer" do
      answer
      visit question_path(question)
      page.find(:xpath, "//*[contains(text(), '#{answer.body}')]/parent::tr").click_button("Delete answer")
      expect(page).to have_content("Your answer has been deleted")
    end
  end
end