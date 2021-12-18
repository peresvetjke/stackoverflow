class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize! :read, User
    head :ok
  end
end