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
    can :read, [Question, Answer, Comment]
  end

  def user_abilities
    can %i[read create], [Question, Answer, Comment]
    can %i[update destroy], [Question, Answer, Comment], author_id: @user.id
    can :read, Awarding, user_id: @user.id
    can :mark_best, Answer, question: { author_id: @user.id }
    can :accept_vote, Votable do |votable|
      votable.author_id != @user.id
    end
    #[Answer, Question].each do |votable_class|
    #  can :accept_vote, votable_class do |votable| 
    #    votable.author_id != @user.id
    #  end
    #end
    
    can :destroy, ActiveStorage::Attachment, record: { author_id: @user.id }
    
    #can :accept_vote, Votable, {|votable| votable.author_id != @user.id}

    #read: [:index, :show]
    #create: [:new, :create]
    #update: [:edit, :update]
    #destroy: [:destroy]
    #manage: ALL!
  end

  def admin_abilities
    can :manage, [Question, Answer, Comment, ActiveStorage::Attachment]
    #can :destroy, ActiveStorage::Attachment
  end
    #can :destroy, ActiveStorage::Attachment, record: { author_id: @user.id }
    
    #answers#mark_best
    #unless current_user&.author_of?(@answer.question)
    #  redirect_to @answer.question, notice: "The answer can be edited only by its author"
    #end    




end
