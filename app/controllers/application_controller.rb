class ApplicationController < ActionController::Base
  before_action :set_current_user, if: -> { current_user.present? }

  def set_current_user
    gon.current_user = current_user
  end
end
