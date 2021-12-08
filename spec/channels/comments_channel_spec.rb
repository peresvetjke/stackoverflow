require 'rails_helper'

RSpec.describe CommentsChannel, type: :channel do
  feature 'User can get new comments through channel', %q{
  In order to have up-to-date info
  } do

    given(:user)     { create(:user) }
    given(:question) { create(:question) }

    scenario "comment appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in "comment_body", with: "New comment"
        click_button "Create Comment"
        expect(page).to have_content("New comment")
      end

      Capybara.using_session('guest') do
        sleep(1)
        expect(page).to have_content("New comment")
      end
    end
  end
end
