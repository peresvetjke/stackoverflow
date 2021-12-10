module FeatureHelpers 
  def confirm_email(email)
    open_email(email)
    current_email.click_link 'Confirm my account'
  end

  def sign_in(user)
    visit new_user_session_path
    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
    click_button "Log in"
  end

  def sign_out
    find("#sign_out").click
  end
end