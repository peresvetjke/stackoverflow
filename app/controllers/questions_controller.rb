class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: %i[new create edit update destroy]
  expose :questions, -> {Question.all}
  expose :question
  expose :answers,   ->{ question.answers }
  expose :answer,    ->{ question.answers.new }

  def index
    
  end

  def show

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

  end

  def update
    if question.update(question_params)
      redirect_to question, notice: "Question has been successfully updated."
    else
      render :edit
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: "Your question has been deleted."
    else
      redirect_to question, notice: "The question can be deleted only by its author"
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end