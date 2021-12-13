class AwardingsController < ApplicationController
  before_action :load_awardings, only: :index
  
  authorize_resource
  
  respond_to :html

  def index
  end

  private

  def load_awardings
    @awardings = current_user.awardings
  end
end