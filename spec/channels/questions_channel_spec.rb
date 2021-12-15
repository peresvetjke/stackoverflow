require 'rails_helper'

RSpec.describe QuestionsChannel, type: :channel do
  feature 'User can get new questions through channel', %q{
  In order to have up-to-date info
  } do

    given(:user) { create(:user) }

    scenario "question appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit new_question_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        fill_in "Title", :with => "New question"
        fill_in "Body", :with => "Body body body"
        click_button "Create Question"
        expect(page).to have_text("Question was successfully created")
        expect(page).to have_content("New question")
      end

      Capybara.using_session('guest') do
        sleep(1)
        expect(page).to have_content("New question")
      end
    end
  end
end
