class AwardingsController < ApplicationController
#   require "mini_magick"

  expose :awardings, -> { current_user.awardings }
  
  def index

  end
end