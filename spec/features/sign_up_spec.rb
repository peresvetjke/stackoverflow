require "rails_helper"

feature 'User can register', %q{
  In order to sign in
  and ask questions or post answers
} do
  
  feature "signs up using login ans password" do
    background { visit new_user_registration_path } 
  
    scenario "tries to register with blank email" do
      fill_in "Email", :with => ""
      fill_in "Password", :with => "password"
      fill_in "Password confirmation", :with => "password"
      click_button "Sign up"
      expect(page).to have_text("Email can't be blank")
    end

    scenario "tries to register with blank password" do
      fill_in "Email", :with => "user@example.com"
      fill_in "Password", :with => ""
      fill_in "Password confirmation", :with => ""
      click_button "Sign up"
      expect(page).to have_text("Password can't be blank")
    end

    scenario "tries to register with confirmation password not matched" do
      fill_in "Email", :with => "user@example.com"
      fill_in "Password", :with => "password"
      fill_in "Password confirmation", :with => "passwordxxx"
      click_button "Sign up"
      expect(page).to have_text("Password confirmation doesn't match")
    end

    scenario "tries to register with email which is taken" do
      user = create(:user)
      fill_in "Email", :with => user.email
      fill_in "Password", :with => user.password
      fill_in "Password confirmation", :with => user.password
      click_button "Sign up"
      expect(page).to have_text("Email has already been taken")
    end

    scenario "registers with correct credentials" do
      fill_in "Email", :with => "user@example.com"
      fill_in "Password", :with => "password"
      fill_in "Password confirmation", :with => "password"
      click_button "Sign up"
      expect(page).to have_text("A message with a confirmation link has been sent")
      open_email('user@example.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_text("Your email address has been successfully confirmed")
    end
  end

  feature "signs up using Github account" do
    feature "without email from provider" do
      background do
        mock_auth_hash(email: nil)
        visit new_user_registration_path
        click_link('Sign in with GitHub')
      end

      it "doesn't ask for a password" do
        expect(page).to have_no_content("Password")
        expect(page).to have_button("Sign up")
      end

      it "asks for an email" do
        expect(page).to have_text 'Please fill in your email to finish registration.'
        expect(page).to have_button("Sign up")
      end
      
      it "sends confirmation email" do
        fill_in "Email", :with => "user@example.com"
        click_button "Sign up"
        expect(page).to have_text("A message with a confirmation link has been sent")  
        open_email('user@example.com')
        current_email.click_link 'Confirm my account'
        expect(page).to have_text("Your email address has been successfully confirmed")
      end
    end


    feature "with email from provider" do
      background do 
        mock_auth_hash
        visit new_user_registration_path
        click_link('Sign in with GitHub')
      end

      it "authenticates user" do
        expect(page).to have_text("Successfully authenticated from Github account")
      end
    end
  end

  feature "signs up using Facebook account" do
    feature "without email from provider" do
      background do
        mock_auth_hash(provider: 'facebook', email: nil)
        visit new_user_registration_path
        click_link('Sign in with Facebook')
      end

      it "doesn't ask for a password" do
        expect(page).to have_no_content("Password")
        expect(page).to have_button("Sign up")
      end

      it "asks for an email" do
        expect(page).to have_text 'Please fill in your email to finish registration.'
        expect(page).to have_button("Sign up")
      end
      
      it "sends confirmation email" do
        fill_in "Email", :with => "user@example.com"
        click_button "Sign up"
        expect(page).to have_text("A message with a confirmation link has been sent")  
        open_email('user@example.com')
        current_email.click_link 'Confirm my account'
        expect(page).to have_text("Your email address has been successfully confirmed")
      end
    end
  end
end