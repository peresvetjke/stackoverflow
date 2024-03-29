# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    if user&.admin?
      admin_abilities
    elsif user
      user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :manage, :search
    can :read, [Question, Answer, Comment]
  end

  def user_abilities
    can :manage, :search
    can :read, User
    can %i[read create], [Question, Answer, Comment]
    can %i[update destroy], [Question, Answer, Comment], author_id: @user.id
    can :subscribe, Question
    can :read, Awarding, user_id: @user.id
    can :mark_best, Answer, question: { author_id: @user.id }
    can :destroy, ActiveStorage::Attachment, record: { author_id: @user.id }
    can :accept_vote, Votable do |votable|
      !@user.author_of?(votable)
    end    
  end

  def admin_abilities
    can :manage, :search
    can :manage, [User, Question, Answer, Comment, ActiveStorage::Attachment]
  end
end
