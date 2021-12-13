class ApplicationController < ActionController::Base
  before_action :set_current_user, if: -> { current_user.present? }
  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end

  def set_current_user
    gon.current_user = current_user
  end
end
