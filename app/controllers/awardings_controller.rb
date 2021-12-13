class AwardingsController < ApplicationController
  authorize_resource
  
  expose :awardings, -> { current_user.awardings }
  
  def index

  end
end