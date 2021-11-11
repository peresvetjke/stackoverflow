require "rails_helper"

feature 'User can sign in', %q{
  In order to ask questions or post answers
} do

  given(:user) { create(:user) }
  background { visit new_user_session_path }

  scenario "User tries to sign in with blank email" do
    fill_in "Email", :with => ""
    fill_in "Password", :with => user.password
    click_button "Log in"

    expect(page).to have_text("Invalid Email or password")
  end

  scenario "User tries to sign in with blank password" do
    fill_in "Email", :with => user.email
    fill_in "Password", :with => ""
    click_button "Log in"

    expect(page).to have_text("Invalid Email or password")
  end  

  scenario "User tries to sign in with incorrect credentials" do
    create(:user)
    fill_in "Email", :with => "123456"
    fill_in "Password", :with => "654321"
    click_button "Log in"

    expect(page).to have_text("Invalid Email or password")
  end

  scenario "User signs in with correct cridentials" do
    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
    click_button "Log in"

    expect(page).to have_text("Signed in successfully")
  end

end