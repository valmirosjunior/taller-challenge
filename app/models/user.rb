class User < ApplicationRecord
  has_many :reservations
  has_many :books, through: :reservations
  
  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
