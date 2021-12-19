class Api::V1::QuestionsController < Api::V1::BaseController
  #before_action :authorize
  authorize_resource only: %i[index show create]
  before_action :load_question, only: %i[show update]

  respond_to :json

  def index
    respond_with Question.all, each_serializer: Api::V1::QuestionsSerializer
  end

  def show
    respond_with @question, serializer: Api::V1::QuestionSerializer
  end

  def create
    authorize! :create, Question
    respond_with @question = Question.create(question_params.merge(author_id: current_resource_owner.id)), serializer: Api::V1::QuestionSerializer
  end

  def update
    authorize! :update, @question
    @question.update(question_params)
    render json: @question, serializer: Api::V1::QuestionSerializer
    # respond_with @question, serializer: Api::V1::QuestionSerializer
  end

  private

  def authorize
    authorize! :read, Question
  end

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, 
                                      links_attributes: [:id, :title, :url, :_destroy], # _destroy?
                                      awarding_attributes: [:title, :image, :_destroy]) # _destroy?
  end
end