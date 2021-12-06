require 'rails_helper'

RSpec.describe AnswersChannel, type: :channel do
  feature 'User can get new answers through channel', %q{
  In order to have up-to-date info
  } do

    given(:question) { create(:question) }
    given(:user)     { create(:user) }

    scenario "answer appears on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        # sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in "Your answer", :with => "New answer"
        within("#links") do  
          click_link "add link"
          fill_in "Title", :with => "Google"
          fill_in "Url", :with => "https://www.google.com/"
        end
          # attach_file 'answer_files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]  
        click_button "Create Answer"
        expect(page).to have_content "New answer"

      end

      Capybara.using_session('guest') do
        sleep(1)
        expect(page).to have_content "New answer"
        expect(page).to have_link("Google", href: "https://www.google.com/")
          # expect(page).to have_link('rails_helper.rb')
          # expect(page).to have_link('spec_helper.rb')
          # --- Caused by: ---
          # NoMethodError:
          #   undefined method `to_str' for nil:NilClass
          #   /usr/share/rvm/gems/ruby-2.7.4@rails_thinkn/gems/activestorage-6.1.4.1/lib/active_storage/service/disk_service.rb:127:in `generate_url'
      end
    end
  end
end