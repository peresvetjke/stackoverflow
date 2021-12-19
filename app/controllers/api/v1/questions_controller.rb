class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :authorize
  before_action :load_question, only: :show

  respond_to :json

  def index
    respond_with Question.all
  end

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