class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy mark_best]
  
  expose :question
  exposure_config :answer_find, find:   ->{ Answer.find(params[:id]) }
  exposure_config :answer_build, build: ->{ question.answers.new(answer_params) }
  expose :answer, with: [:answer_find, :answer_build]
  expose :answers,                      ->{ question.answers.select{|a| a.persisted?} }

  def edit
    redirect_to answer.question, notice: "The answer can be edited only by its author" unless current_user&.author_of?(answer)
  end

  def update
    return redirect_to answer.question, notice: "The answer can be edited only by its author" unless current_user&.author_of?(answer)

    if answer.update(answer_params)
      redirect_to answer.question, notice: "Answer has been successfully updated."
    else
      render :edit
    end  
  end

  def create
    answer.author = current_user
    answer.save
  end

  def destroy
    return redirect_to answer.question, notice: "The answer can be deleted only by its author" unless current_user&.author_of?(answer)

    answer.destroy
  end

  def mark_best
    return redirect_to answer.question, notice: "The answer can be edited only by its author" unless current_user&.author_of?(answer.question)
    answer.mark_best!
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :body)
  end
end