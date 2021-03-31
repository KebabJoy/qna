class Badge < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  validates :name, presence: true
  validates :img_url, presence: true, format: { with: /\.(jpg|png)\z/i }
end
