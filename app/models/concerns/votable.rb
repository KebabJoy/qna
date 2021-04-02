module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def votes_sum
    votes.sum(:value)
  end

  def upvote(user)
    delete_previous_vote(user) if voted?(user)
    votes.create(value: 1, user: user, votable: self)
  end

  def vote_down(user)
    delete_previous_vote(user) if voted?(user)
    votes.create(value: -1, user: user, votable: self)
  end

  def undo_vote(user)
    delete_previous_vote(user)
  end

  private

  def voted?(user)
    votes.where(user: user).count == 1
  end

  def delete_previous_vote(user)
    vote = votes.where(user: user).last
    vote&.destroy
  end
end
