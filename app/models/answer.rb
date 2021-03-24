class Answer < ApplicationRecord
  default_scope { order(best: :desc) }

  has_many_attached :files

  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  validates :body, presence: true

  def best!
    transaction do
      if question.has_best_answer?
        best_answer = question.answers.find_by(best: true)
        best_answer.update!(best: false)
      end

      update!(best: true)
    end
  end
end
