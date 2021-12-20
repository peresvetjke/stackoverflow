class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource only: %i[index show create]
  before_action :load_answer, only: %i[show update destroy]
  before_action :load_question, only: %i[index create]

  respond_to :json

  def index
    respond_with @question.answers, each_serializer: Api::V1::AnswersSerializer
  end

  def show
    respond_with @answer, serializer: Api::V1::AnswerSerializer
  end

  def create
    authorize! :create, Answer

    respond_with @answer = @question.answers.create(answer_params.merge(author_id: current_resource_owner.id)), serializer: Api::V1::AnswerSerializer
  end

  def update
    authorize! :update, @answer
    
    if @answer.update(answer_params)
      respond_to do |format|
        format.json { render json: @answer, serializer: Api::V1::AnswerSerializer }
      end
    else
      respond_to do |format|
        format.json { render json: { "errors": @answer.errors }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :destroy, @answer
    
    respond_with(@answer.destroy)
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :body, 
                                      links_attributes: [:id, :title, :url, :_destroy])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
  
  def load_answer
    @answer = Answer.find(params[:id])
  end
end