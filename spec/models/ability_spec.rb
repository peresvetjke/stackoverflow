require 'cancan/matchers'
require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  context 'when is a guest' do
    let(:user) { nil }
    
    [Question, Answer, Comment].each do |klass|
      it { is_expected.to be_able_to(:read, klass.new) }
      it { is_expected.not_to be_able_to(:update, klass.new) }
      it { is_expected.not_to be_able_to(:destroy, klass.new) }
    end
    it { is_expected.not_to be_able_to(:read, Awarding.new(user: create(:user))) }
    it { is_expected.not_to be_able_to(:accept_vote, Question.new) }
    it { is_expected.not_to be_able_to(:accept_vote, Answer.new) }
    it { is_expected.not_to be_able_to(:destroy, ActiveStorage::Attachment.new) }
  end

  context 'when logged in' do
    let(:user) { create(:user) }

    it { is_expected.to be_able_to(:read, User) }

    context "not an author" do
      [Question, Answer, Comment].each do |klass|
        it { is_expected.not_to be_able_to(:update, klass.new(author: create(:user))) }
        it { is_expected.not_to be_able_to(:destroy, klass.new(author: create(:user))) }
      end

      [Question, Answer].each do |klass|
        it { is_expected.to be_able_to(:accept_vote, klass.new(author: create(:user))) }
      end

      it { is_expected.not_to be_able_to(:read, Awarding.new(user: create(:user))) }
      it { is_expected.not_to be_able_to(:destroy, ActiveStorage::Attachment.new(record: create(:question, author: create(:user)))) }
      it { is_expected.not_to be_able_to(:mark_best, Answer.new(author: user, question: create(:question, author: create(:user)))) }
    end

    context 'an author' do
      [Question, Answer, Comment].each do |klass|
        it { is_expected.to be_able_to(:create, klass.new(author: user)) }
        it { is_expected.to be_able_to(:update, klass.new(author: user)) }
        it { is_expected.to be_able_to(:destroy, klass.new(author: user)) }
      end

      [Question, Answer].each do |klass|
        it { is_expected.not_to be_able_to(:accept_vote, klass.new(author: user)) }
      end

      it { is_expected.to be_able_to(:read, Awarding.new(user: user)) }
      it { is_expected.to be_able_to(:destroy, ActiveStorage::Attachment.new(record: create(:question, author: user))) }
      it { is_expected.to be_able_to(:mark_best, Answer.new(author: user, question: create(:question, author: user))) }
    end
  end

  context 'when is admin' do
    let(:user) { create(:user, admin: true) }

    [User, Question, Answer, Comment, ActiveStorage::Attachment].each do |klass|
      it { is_expected.to be_able_to(:manage, klass.new) }
    end
  end
end