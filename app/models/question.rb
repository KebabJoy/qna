# frozen_string_literal: true

class Question < ApplicationRecord
  include Votable

  belongs_to :author, class_name: 'User', foreign_key: 'author_id'

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :comments, dependent: :destroy, as: :commentable
  has_one :badge, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :badge, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :calculate_reputation

  scope :recent_questions, -> { where('created_at > ?', 1.day.ago) }

  def has_best_answer?
    answers.where(best: true).exists?
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
