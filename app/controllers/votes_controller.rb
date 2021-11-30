class VotesController < ApplicationController
  before_action :authenticate_user!, only: :accept
  before_action :set_votable, only: :accept
  # before_action :set_vote, only: :accept

  def accept
    @votable.accept_vote(preference: params[:preference], author: current_user)
    respond_to do |format|
      format.json { render json: @votable.with_rating }
    end
    # redirect_to @votable
  end

  private

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