# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can %i[destroy update], [Question, Answer], author_id: @user.id

    can %i[vote_for vote_against], [Question, Answer] do |votable|
      !@user.author_of?(votable)
    end

    can :cancel_vote, [Question, Answer] do |votable|
      votable.votes.where(user: @user).exists?
    end

    can :make_best, Answer do |answer|
      @user.author_of?(answer.question)
    end

    can :destroy, Link do |link|
      @user.author_of?(link.linkable)
    end
  end
end
