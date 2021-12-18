class Api::V1::ProfilesController < Api::V1::BaseController
  before_action :doorkeeper_authorize!

  def me
    authorize! :read, User
    head :ok
  end
end