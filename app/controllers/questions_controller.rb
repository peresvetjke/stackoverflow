class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  
  before_action :load_questions, only: :index
  before_action :load_question,  except: %i[index new create]
  before_action :load_answers,  only: :show
  before_action :load_comments, only: :show

  authorize_resource

  respond_to :html

  def index
    respond_with(@questions)
  end

  def show
    gon.question_id = @question.id
    respond_with(@question)
  end

  def new
  end

  def create
    respond_with(Question.create(question_params.merge(author_id: current_user.id)))
  end

  def edit
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, 
                                      files: [], links_attributes: [:id, :title, :url, :_destroy],
                                      awarding_attributes: [:title, :image, :_destroy])
  end

  def load_questions
    @questions = Question.with_attached_files
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def load_answers
    @answers = @question.answers.with_attached_files
  end

  def load_comments
    @comments = @question.comments
  end
end