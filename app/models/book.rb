class Book < ApplicationRecord
  has_many :reservations
  has_many :users, through: :reservations
  
  validates :title, presence: true
  validates :status, inclusion: { in: %w[available reserved] }
end
