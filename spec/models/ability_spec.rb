require 'cancan/matchers'
require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  context 'when is a guest' do
    let(:user) { nil }
    
    it { is_expected.not_to be_able_to(:manage, Question.new) }
    it { is_expected.to be_able_to(:read, Question.new) }
    it { is_expected.to be_able_to(:read, Answer.new) }
    it { is_expected.to be_able_to(:read, Comment.new) }
  end

  context 'when logged in but not an author' do
    let(:user) { create(:user) }

    it { is_expected.not_to be_able_to(:manage, Question.new(author: create(:user))) }
    it { is_expected.not_to be_able_to(:manage, Answer.new(author: create(:user))) }
    it { is_expected.not_to be_able_to(:manage, Comment.new(author: create(:user))) }
  end

  context 'when logged in as an author' do
    let(:user) { create(:user) }

    it { is_expected.to be_able_to(:manage, Question.new(author: user)) }
    it { is_expected.to be_able_to(:manage, Answer.new(author: user)) }
    it { is_expected.to be_able_to(:manage, Comment.new(author: user)) }
  end

  context 'when is admin' do
    let(:user) { create(:user, admin: true) }

    it { is_expected.to be_able_to(:manage, Question.new) }
    it { is_expected.to be_able_to(:manage, Answer.new) }
    it { is_expected.to be_able_to(:manage, Comment.new) }
  end
end