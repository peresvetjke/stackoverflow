require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder

  before_action :set_current_user, if: -> { current_user.present? }
  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    if current_user.nil?
      session[:next] = request.fullpath
      redirect_to login_url, alert: 'You have to log in to continue.'
    else
      exception.default_message = "Not authorized"
      respond_to do |format|
        format.json { render json: exception.message, status: :forbidden }
        format.js   { render js: exception.message, status: :forbidden }
        format.html { redirect_to main_app.root_url, alert: exception.message }
      end
    end
  end

  def set_current_user
    gon.current_user = current_user
  end
end
