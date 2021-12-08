require "rails_helper"

feature 'User can destroy comment', %q{
  In order to delete it completely
} do

  given(:user)          { create(:user) }
  given(:question)      { create(:question, author: user) }
  given(:comment)       { create(:comment, author: user, commentable: question) }
  given(:other_user)    { create(:user) }
  given(:other_comment) { create(:comment, author: other_user, commentable: question) }

  feature "being unauthorized" do
    scenario "tries to delete answer" do
      visit question_path(question)
      expect(page).to have_no_link("Delete")
    end
  end

  feature "being authorized", js: true do
    background { sign_in(user) }
    
    scenario "tries to delete other's comment" do
      other_comment
      visit question_path(question)
      expect(find(".comment", text: other_comment.body)).to have_no_link("Delete")
    end

    scenario "deletes own comment" do
      comment
      visit question_path(question)
      within(".comment", text: comment.body) do
        accept_alert { click_link("Delete") }
      end
      accept_alert
      expect(page).to have_no_content(comment.body)
    end
  end
end