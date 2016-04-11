class Gram < ActiveRecord::Base
  validates :message, presence: true
  validates :picture, presence: true

  belongs_to :user
  has_many :comments

  mount_uploader :picture, PictureUploader
end
