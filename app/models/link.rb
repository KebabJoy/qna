class Link < ApplicationRecord
  URL_REGEX = %r{\A(https?://)?([\da-z\.-]+)\.([a-z\.]{2,6})([/\w\.-]*)*/?\Z}i.freeze

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates_format_of :url, with: URL_REGEX
end
