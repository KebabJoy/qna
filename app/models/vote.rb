class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validate :validate_user

  private

  def validate_user
    errors.add(:vote, "Author can't vote for his #{votable.class.name}") if votable && user.author_of?(votable)
  end
end
