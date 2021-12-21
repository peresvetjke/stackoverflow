class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User, except: :me

  respond_to :json

  def me
    authorize! :read, User
    respond_with current_resource_owner
  end

  def index
    respond_with User.where.not(id: current_resource_owner)
  end
end