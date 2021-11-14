# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

5.times do |u|
  user = User.create!(email: "user#{u+1}@mail.ru", password: "xxxxxx")
end

10.times do |q|
  question_author = User.all.sample
  question = question_author.questions.create!(title: "Question ##{q+1}", body: "question body")

  5.times do |a|
    answer_author = User.where.not(id: question_author.id).sample
    answer = question.answers.create!(body: "Answer ##{a+1} for question ##{question.id}", author_id: answer_author.id)
  end
end
