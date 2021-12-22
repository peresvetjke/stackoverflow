class DailyDigestMailer < ApplicationMailer
  def digest(user, new_answers)
    @user = user
    @updated = new_answers.group_by(&:question)

    mail to: user.email
  end
end
