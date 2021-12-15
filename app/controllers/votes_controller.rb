class VotesController < ApplicationController
  before_action :set_votable, only: :accept
  before_action :authorize_resource, only: :accept
  before_action :authenticate_user!, only: :accept

  respond_to :json

  def accept
    respond_to do |format|
      @votable.accept_vote(preference: params[:preference], author: current_user)
      format.json { render json: @votable.with_rating }
    end
  end

  private

  def authorize_resource
    authorize! :accept_vote, @votable
  end

  def set_votable
    @votable = votable_name.classify.constantize.find(params[:id])
  end

  def votable_name
    params[:votable]
  end

  def vote_params
    params.require(:vote).permit(:preference)
  end
end