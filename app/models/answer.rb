class Answer < ApplicationRecord
  default_scope { order(best: :desc) }

  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  accepts_nested_attributes_for :links, reject_if: :all_blank

  belongs_to :question
  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  validates :body, presence: true

  def best!
    transaction do
      if question.has_best_answer?
        best_answer = question.answers.find_by(best: true)
        best_answer.update!(best: false)
      end

      author.badges.push(question.badge)
      update!(best: true)
    end
  end
end
