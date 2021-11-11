class AnswersController < ApplicationController
  expose :question
  expose :answers, ->{ question.answers.select{|a| a.persisted?} }
  expose :answer,  ->{ question.answers.new(answer_params) }

  def create
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