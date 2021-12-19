class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :authorize
  before_action :load_question

  respond_to :json

  def show
    respond_with @question
  end

  private

  def authorize
    authorize! :read, Question
  end

  def load_question
    @question = Question.find(params[:id])
  end
end