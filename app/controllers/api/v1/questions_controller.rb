class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource only: %i[index show create]
  before_action :load_question, only: %i[show update destroy]

  respond_to :json

  def index
    respond_with Question.all, each_serializer: Api::V1::QuestionsSerializer
  end

  def show
    respond_with @question, serializer: Api::V1::QuestionSerializer
  end

  def create
    respond_with @question = Question.create(question_params.merge(author_id: current_resource_owner.id)), serializer: Api::V1::QuestionSerializer
  end

  def update
    authorize! :update, @question

    respond_to do |format|
      if @question.update(question_params)
        format.json { render json: @question, serializer: Api::V1::QuestionSerializer }
      else
        format.json { render json: { "errors": @question.errors }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize! :destroy, @question
    
    respond_with(@question.destroy)
  end

  private

  def load_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, 
                                      links_attributes: [:id, :title, :url, :_destroy], # _destroy?
                                      awarding_attributes: [:title, :image, :_destroy]) # _destroy?
  end
end