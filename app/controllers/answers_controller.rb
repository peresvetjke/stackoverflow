class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy mark_best]
  
  expose :question
  exposure_config :answer_find, find:   ->{ Answer.with_attached_files.find(params[:id]) }
  exposure_config :answer_build, build: ->{ question.answers.new(answer_params) }
  expose :answer, with: [:answer_find, :answer_build]
  expose :answers,                      ->{ question.answers.with_attached_files.select{|a| a.persisted?} }

  def edit
    redirect_to answer.question, notice: "The answer can be edited only by its author" unless current_user&.author_of?(answer)
  end

  def update
    unless current_user&.author_of?(answer)
      return redirect_to answer.question, notice: "The answer can be edited only by its author"
    end

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
    if current_user&.author_of?(answer)
      answer.destroy
    else 
      redirect_to answer.question, notice: "The answer can be deleted only by its author"
    end
  end

  def mark_best
    if current_user&.author_of?(answer.question)
      answer.mark_best!  
    else 
      redirect_to answer.question, notice: "The answer can be edited only by its author"
    end
  end

  def vote
    answer.accept_vote(author: user, preference: params[:preference])
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :body, 
                                      files: [], links_attributes: [:id, :title, :url, :_destroy])
  end
end