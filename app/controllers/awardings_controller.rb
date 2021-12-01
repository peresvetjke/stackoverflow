class AwardingsController < ApplicationController

  expose :awardings, -> { current_user.awardings }
  
  def index

  end
end