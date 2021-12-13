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

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end

  private

  def guest_abilities
    can :read, [Question, Answer, Comment]
  end

  def user_abilities
    can :manage, [Question, Answer, Comment], author_id: @user.id
    can :index, Awarding
    can :accept, Vote
    can :destroy, ActiveStorage::Attachment, record: { author_id: @user.id }
  end

  def admin_abilities
    can :manage, [Question, Answer, Comment]
  end

  #def record(attachment)
  #  instance_eval("#{attachment.record_type}.find(#{attachment.record_id})")
  #end
end
