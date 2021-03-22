class Question < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def has_best_answer?
    answers.where(best: true).exists?
  end
end
