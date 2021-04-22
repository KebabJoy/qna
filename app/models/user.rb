class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :authored_questions, class_name: 'Question', foreign_key: 'author_id', dependent: :nullify
  has_many :authored_answers, class_name: 'Answer', foreign_key: 'author_id', dependent: :nullify
  has_many :comments, class_name: 'Comment', foreign_key: 'user_id', dependent: :nullify
  has_many :votes, dependent: :destroy, as: :votable
  has_many :badges
  has_many :subscriptions, dependent: :destroy

  scope :all_except, ->(user) { where('id != ?', user.id) }


  def author_of?(resource)
    resource.author_id == id
  end

  def subscribed?(resource)
    Subscriptions.where(user: self, question: resource).exists?
  end
end
