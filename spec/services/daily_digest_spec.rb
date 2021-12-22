require 'rails_helper'

RSpec.describe DailyDigest do
  let!(:questions)                 { create_list(:question, 5, :unsubscribed) }
  let!(:users)                     { questions.map(&:author) }
  # let(:other_user)                { create(:user) }
  

  it "sends daily digest to all users" do
    binding.pry
    users.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user, questions.to_a, []).and_call_original }
    subject.send_digest
  end

  # let(:question_with_new_answers) { create(:question, :with_answers, author: user) }
  # let(:new_answers)               { question_with_new_answers.answers.to_a }
  context "with new answers" do
    it 'sends daily digest to subscribed users' do
      expect(DailyDigestMailer).to receive(:digest).with(user, new_answers).and_call_original
      subject.send_digest    
    end

    it "doesn't send digest to not subscribed users" do
      allow(DailyDigestMailer).to receive(:digest).and_call_original
      expect(DailyDigestMailer).not_to receive(:digest).with(other_user, new_answers)
      subject.send_digest
    end
  end

  context "without new answers" do
    it "doesn't send daily digest" do
      expect(DailyDigestMailer).not_to receive(:digest)
      subject.send_digest
    end
  end
end