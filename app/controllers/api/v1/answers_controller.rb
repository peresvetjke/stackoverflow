class Api::V1::AnswersController < Api::V1::BaseController
  before_action :authorize
  before_action :load_question, only: :index

  respond_to :json

  def index
    respond_with @question.answers, each_serializer: Api::V1::AnswersSerializer
  end

  private

  def authorize
    authorize! :read, Answer
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end