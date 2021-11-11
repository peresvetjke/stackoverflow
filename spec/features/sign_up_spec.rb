require "rails_helper"

feature 'User can register', %q{
  In order to sign in
  and ask questions or post answers
  I'd like to be able to register
} do

  scenario "email is blank" do
    visit "/sign_up"

    fill_in "email", :with => ""
    fill_in "password", :with => "password"
    fill_in "confirmation_password", :with => "password"
    click_button "Sign up"

    expect(page).to have_text("Email can't be blank.")
  end

  scenario "confirmation password doesn't match" do
    visit "/sign_up"

    fill_in "email", :with => "email"
    fill_in "password", :with => "password"
    fill_in "confirmation_password", :with => "password123"
    click_button "Sign up"

    expect(page).to have_text("Confirmation password doesn't match.")
  end

  scenario "email is taken" do
    create(:user, email: "user@example.com")

    visit "/sign_up"

    fill_in "email", :with => "user@example.com"
    fill_in "password", :with => "password"
    fill_in "confirmation_password", :with => "password123"
    click_button "Sign up"

    expect(page).to have_text("Email is taken.")
  end

  scenario "confirmation password matches and email is correct" do
    visit "/sign_up"

    fill_in "email", :with => "user@example.com"
    fill_in "password", :with => "password"
    fill_in "confirmation_password", :with => "password"
    click_button "Sign up"

    expect(page).to have_text("You have successfully registered.")
  end

end

=begin
  - Пользователь может войти в систему
  - Пользователь может выйти из системы
  - Пользователь может зарегистрироваться в системе
=end