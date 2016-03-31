class Gram < ActiveRecord::Base
  validates :message, presence: true

  belongs_to :user
end
