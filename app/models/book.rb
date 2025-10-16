class Book < ApplicationRecord
  has_many :reservations
  has_many :users, through: :reservations
  
  enum :status, { available: 'available', reserved: 'reserved' }, default: :available
  
  validates :title, presence: true
end
