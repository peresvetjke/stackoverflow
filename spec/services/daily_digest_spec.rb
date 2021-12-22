require 'rails_helper'

RSpec.describe DailyDigest do
  context "without new answers" do
    let!(:questions)                 { create_list(:question, 5, :unsubscribed) }
    let!(:users)                     { create_list(:user, 5) }

    it "sends new questions to all users without answers list" do
      stub_const("DailyDigest::TIME_RANGE", (Time.now - 1.day)..Time.now)
      User.all.each { |user| expect(DailyDigestMailer).to receive(:digest).with(user, questions.to_a, []).and_call_original }
      subject.send_digest
    end
  end

  context "with new answers" do
    context "without followers" do
      let!(:user)         { create(:user) }
      let!(:question)     { create(:question, :unsubscribed, author: user) }
      let!(:answers)      { create_list(:answer, 5, question: question, author: user) }

      it 'sends new questions to all users without answers list' do
        stub_const("DailyDigest::TIME_RANGE", (Time.now - 1.day)..Time.now)
        expect(DailyDigestMailer).to receive(:digest).with(user, [question], []).and_call_original
        subject.send_digest    
      end
    end

    context "with followers" do
      let!(:user)         { create(:user) }
      let!(:question)     { create(:question, author: user) }
      let!(:answers)      { create_list(:answer, 5, question: question, author: user) }
      let!(:follower)     { create(:user) }
      let!(:subscription) { create(:subscription, question: question, user: follower) }

      it 'sends new answers list to subscribed users' do
        stub_const("DailyDigest::TIME_RANGE", (Time.now - 1.day)..Time.now)
        expect(DailyDigestMailer).to receive(:digest).with(user, [question], answers.to_a).and_call_original
        expect(DailyDigestMailer).to receive(:digest).with(follower, [question], answers.to_a).and_call_original
        subject.send_digest    
      end
    end
  end
end