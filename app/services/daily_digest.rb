class DailyDigest
  TIME_RANGE = (Time.now - 1.day)..Time.now

  def send_digest
    new_questions = Question.where(created_at: TIME_RANGE).to_a

    User.find_each(batch_size: 500) do |user| 
      new_answers = Answer.recent_answers_for_follower(user).to_a
      DailyDigestMailer.digest(user, new_questions, new_answers).deliver_now
    end
  end
end