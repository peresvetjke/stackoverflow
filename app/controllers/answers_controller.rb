class AnswersController < ApplicationController
  before_action :authenticate_user!, only: :create
  expose :question
  expose :answers, ->{ question.answers.select{|a| a.persisted?} }
  expose :answer,  ->{ question.answers.new(answer_params) }

  def create
    answer.author = current_user
    if answer.save
      redirect_to answer.question, notice: "Answer has been succesfully posted."
    else
      render "questions/show"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :body)
  end
end