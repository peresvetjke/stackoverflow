require "rails_helper"

feature 'User can sign out', %q{
  In order to destroy session and pass PC to a friend
} do

  background { 
    sign_in(create(:user))
  }

  scenario "User signs out" do
    click_link "Sign out"

    expect(page).to have_text("Signed out successfully")
  end

end