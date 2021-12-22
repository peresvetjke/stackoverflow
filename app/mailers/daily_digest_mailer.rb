class DailyDigestMailer < ApplicationMailer
  def digest(user, new_questions, new_answers)
    @user = user
    @new_questions = new_questions
    @new_answers = new_answers.group_by(&:question)

    mail to: user.email
  end
end
