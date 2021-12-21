require "rails_helper"

feature 'User subscribe on a question', %q{
  to get notifications about its updates
} do

  let(:question) { create(:question) }

  scenario "guest" do
    visit question_path(question)
    expect(page).to have_no_button("Subscribe")
    expect(page).to have_no_button("Unsubscribe")
  end
  
  feature "authenticated", js: true do
    let(:user) { create(:user) }
    let(:subscription) { create(:subscription, question: question, user: user) }    
    
    background { sign_in(user) }

    feature "being unsubscribed" do
      scenario "subscribes" do
        visit question_path(question)
        expect(page).to have_no_button("Unubscribe")
        find(".subscribe").click
        msg = accept_confirm{}
        expect(msg).to eq "You have been successfully subscribed to question."
        expect(page).to have_button("Unsubscribe")
      end
    end

    feature "being unsubscribed" do
      background { subscription }
      
      scenario "subscribes" do
        visit question_path(question)
        expect(page).to have_no_button("Subscribe")
        visit question_path(question)
        find(".subscribe").click
        msg = accept_confirm{}
        expect(msg).to eq "You have been successfully unsubscribed from question."
        expect(page).to have_button("Subscribe")
      end
    end
  end
end