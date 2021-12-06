require "rails_helper"

feature 'User can post comment', %q{
  In order to discuss some commentable details
} do

  given(:question) { create(:question) }

  feature "being unauthorized", js: true do

    scenario "tries to create comment" do
      visit question_path(question)
      expect(page).to have_no_button("Create Comment")
    end
  end

  feature "being authorized", js: true do
    given(:user)       { create(:user) }
    given(:answer)     { create(:answer, question: question) }

    background {
      sign_in(user)
      visit question_path(question)
    }

    scenario "tries to create comment with blank body" do
      fill_in "comment_body", with: ""
      click_button "Create Comment"
      expect(page).to have_text("Body can't be blank")
    end

    scenario "creates comment" do
      #save_and_open_page
      fill_in "comment_body", with: "New comment"
      click_button "Create Comment"
      expect(page).to have_content("New comment")
    end
  end
end