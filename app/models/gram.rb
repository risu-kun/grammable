class Gram < ActiveRecord::Base
  validates :message, presence: true
end
