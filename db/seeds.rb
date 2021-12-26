# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

SEARCH_TAGS = ['foo', 'bar']

5.times { |u| user = User.create!(email: "user#{u+1}@mail.ru", password: "xxxxxx", confirmed_at: Time.now) }

10.times do |q|
  question = User.all.sample.questions.create!(title: "Question ##{q+1}", body: "question body; #{SEARCH_TAGS.sample}")
  5.times { |a| question.answers.create!(body: "Answer ##{a+1} for question ##{question.id}; #{SEARCH_TAGS.sample}", author_id: User.all.sample.id) }
end

(Question.all + Answer.all).each { |commentable| commentable.comments.create!(body: "Comment; #{SEARCH_TAGS.sample}", author: User.all.sample) }