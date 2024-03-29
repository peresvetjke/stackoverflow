require "rails_helper"

feature 'User can sign in', %q{
  In order to ask questions or post answers
} do

  given(:user) { create(:user) }
  background { 
    visit questions_path
    find('#sign_in').click
  }

  scenario "tries to sign in with blank email" do
    fill_in "Email", :with => ""
    fill_in "Password", :with => user.password
    click_button "Log in"
    expect(page).to have_text("Invalid Email or password")
  end

  scenario "tries to sign in with blank password" do
    fill_in "Email", :with => user.email
    fill_in "Password", :with => ""
    click_button "Log in"
    expect(page).to have_text("Invalid Email or password")
  end  

  scenario "tries to sign in with incorrect credentials" do
    fill_in "Email", :with => "1234@asd.com"
    fill_in "Password", :with => "654321"
    click_button "Log in"
    expect(page).to have_text("Invalid Email or password")
  end

  scenario "signs in with correct cridentials" do
    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
    click_button "Log in"
    expect(page).to have_text("Signed in successfully")
  end

  feature "signs in with Facebook account" do
    background do 
      mock_auth_hash(provider: 'facebook')
      visit new_user_registration_path
      click_link('Sign in with Facebook')
    end

    it "authenticates user" do
      expect(page).to have_text("Successfully authenticated from Facebook account")
    end
  end
end