# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :generate_password,     only: :create, if: -> { omni_authed? }
  after_action  -> { create_authentication resource }, only: :create, if: -> { omni_authed? && resource.persisted? }

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    email = params[:user][:email]
    user = User.find_by(email: email)
    if user
      create_authentication resource
      return sign_in_and_redirect user, event: :authentication
    end
    
    super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #  super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  private

  def omni_authed?
    session["oauth.uid"].present? && session["oauth.provider"].present?
  end

  def generate_password
    params[:user][:password] = Devise.friendly_token[0, 20]
  end

  def create_authentication
    resource.create_authentication(provider: session["oauth.provider"], uid: session["oauth.uid"])
    clear_oauth_session
  end

  def clear_oauth_session
    session.delete("oauth.uid")
    session.delete("oauth.provider")
  end
end
