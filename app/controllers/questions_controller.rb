class QuestionsController < ApplicationController
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
    if question.save
      redirect_to question, notice: "Question has been successfully created."
    else
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end