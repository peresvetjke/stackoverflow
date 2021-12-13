class QuestionsController < ApplicationController
  authorize_resource
  
  before_action :authenticate_user!, only: %i[new create edit update destroy]

  expose :question, find:   -> { Question.with_attached_files.find(params[:id]) }
  expose :questions,        -> { Question.with_attached_files }
  expose :answers,          -> { question.answers.with_attached_files }
  expose :answer,           -> { question.answers.new }
  expose :comments,         -> { question.comments }
  expose :comment,          -> { question.comments.new }

  def index
    
  end

  def show
    gon.question_id = question.id
  end

  def new
    
  end

  def create
    question.author = current_user
    if question.save
      redirect_to question, notice: "Question has been successfully created."
    else
      render :new
    end
  end

  def edit
    redirect_to question, notice: "The question can be edited only by its author" unless current_user.author_of?(question)
  end

  def update
    return redirect_to question, notice: "The question can be edited only by its author" unless current_user.author_of?(question)
    if question.update(question_params)
      redirect_to question, notice: "Question has been successfully updated."
    else
      render :edit
    end
  end

  def destroy
    return redirect_to question, notice: "The question can be deleted only by its author" unless current_user.author_of?(question)

    question.destroy
    redirect_to questions_path, notice: "Your question has been deleted."
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, 
                                      files: [], links_attributes: [:id, :title, :url, :_destroy],
                                      awarding_attributes: [:title, :image, :_destroy])
  end
end