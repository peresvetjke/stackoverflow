=begin
require "rails_helper"

RSpec.feature "Sign in", :type => :feature do


  feature 'User can sign in', %q{
    In order to ask questions
    As an unauthenticated user
    I'd like to be able to sign in
  } do


    scenario "Registered user can sign in" do
      visit "/sign_in"

      fill_in "login", :with => "login"
      fill_in "password", :with => "password"
      click_button "Sign in"

      expect(page).to have_text("You have successfully signed in.")
    end

    scenario "User can sign out" do
      visit "/sign_out"

      expect(page).to have_text("You have successfully signed out.")
    end

    scenario "User can register" do
      visit "/sign_up"

      fill_in "login", :with => "login"
      fill_in "password", :with => "password"
      fill_in "password_cofirmation", :with => "password"
      click_button "Sign up"

      expect(page).to have_text("You have successfully signed up.")
    end
  end

end
=end
=begin
  - Пользователь может войти в систему
  - Пользователь может выйти из системы
  - Пользователь может зарегистрироваться в системе
=end