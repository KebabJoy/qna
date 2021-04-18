class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :comments, :links, :files

  has_many :comments
  has_many :links

  belongs_to :author

  def files
    object.files.map { |file| { url: file.url } } if object.files.attached?
  end
end
