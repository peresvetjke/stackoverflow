class AnswersController < ApplicationController
  before_action :load_question, only: :create
  before_action :load_answer,   except: :create
  authorize_resource
  before_action :authenticate_user!, only: %i[create destroy mark_best]

  respond_to :html, only: %i[edit update]
  respond_to :js, only: %i[create destroy mark_best]

  def show
    respond_with(@answer)
  end

  def edit
  end

  def update
    @answer.update(answer_params)
    respond_with @answer, location: -> { @answer.question }
  end

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(author_id: current_user.id)))
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def mark_best
    @answer.mark_best!
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :body, 
                                      files: [], links_attributes: [:id, :title, :url, :_destroy])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end