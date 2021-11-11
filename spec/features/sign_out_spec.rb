require "rails_helper"

feature 'User can sign out', %q{
  In order to destroy session and pass PC to a friend
} do

  given(:user) { create(:user) }
  background { 
    visit new_user_session_path
    
    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
    click_button "Log in"
  }

  scenario "User signs out" do
    click_button "Sign out"

    expect(page).to have_text("Signed out successfully")
  end

end