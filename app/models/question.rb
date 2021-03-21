class Question < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def has_best_answer?
    answers.where(best: true).count == 1
  end

  def remove_best_answer
    best_answer = answers.find_by(best: true)

    Answer.transaction do
      best_answer.update!(best: false)
    end
  end
end
