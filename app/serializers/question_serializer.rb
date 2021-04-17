class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title, :comments, :links, :files
  has_many :answers
  has_many :comments
  has_many :links

  belongs_to :author

  def short_title
    object.title.truncate(7)
  end

  def files
    object.files.map { |file| { url: file.url } } if object.files.attached?
  end
end
