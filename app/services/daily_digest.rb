class DailyDigest
  def send_digest
    User.find_each(batch_size: 500) do |user|
      new_answers = []
      
      user.followed_questions.each do |question| 
        answers = question.answers.where(created_at: (Time.now - 1.day)..Time.now).to_a
        new_answers += answers if answers.present?
      end

      DailyDigestMailer.digest(user, new_answers).deliver_later unless new_answers.empty?
    end
  end
end