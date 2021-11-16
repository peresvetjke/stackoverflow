class AnswersController < ApplicationController
  before_action :authenticate_user!, only: :create
  
  expose :question
  exposure_config :answer_find, find:   ->{ Answer.find(params[:id]) }
  exposure_config :answer_build, build: ->{ question.answers.new(answer_params) }
  expose :answer, with: [:answer_find, :answer_build]
  expose :answers,                      ->{ question.answers.select{|a| a.persisted?} }

  def create
    answer.author = current_user
    answer.save
  end

  def destroy
    question = answer.question
    if current_user&.author_of?(answer)
      answer.destroy
      redirect_to question_path(question), notice: "Your answer has been deleted."
    else
      redirect_to question_path(question), notice: "The answer can be deleted only by its author"
    end    
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :body)
  end
end