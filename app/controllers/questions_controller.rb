class QuestionsController < ApplicationController
  expose :question
  expose :answers, ->{ question.answers }
  expose :answer,  ->{ question.answers.new }

  def index
    
  end

  def show

  end

  def new

  end

  def create
    if question.save
      redirect_to question
    else
      render :new
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end