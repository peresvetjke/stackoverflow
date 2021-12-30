class Search::AnswersSerializer < ApplicationSerializer
  attributes :id, :body, :author_email, :question_title, :question_id

  def question_title
    object.question.title
  end
end