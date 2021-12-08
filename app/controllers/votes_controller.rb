class VotesController < ApplicationController
  before_action :authenticate_user!, only: :accept
  before_action :set_votable, only: :accept

  def accept
    respond_to do |format|
      if current_user.author_of?(@votable)
        format.json { render json: "You can't vote for your own record.", status: :unprocessable_entity }
      else
        @votable.accept_vote(preference: params[:preference], author: current_user)
        format.json { render json: @votable.with_rating }
      end
    end
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