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
    cannot :mark_best, Answer, question: { author_id: @user.id }
    can :read, [Question, Answer, Comment]
    can :manage, [Question, Answer, Comment], author_id: @user.id
    #can :index, Awarding
    #can :accept, Vote,
  end
    #can :destroy, ActiveStorage::Attachment, record: { author_id: @user.id }
    
    #answers#mark_best
    #unless current_user&.author_of?(@answer.question)
    #  redirect_to @answer.question, notice: "The answer can be edited only by its author"
    #end    


  def admin_abilities
    can :manage, [Question, Answer, Comment]
  end

end
