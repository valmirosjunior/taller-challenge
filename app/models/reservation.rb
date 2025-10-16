class Reservation < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validate :book_must_be_available, on: :create
  around_create :create_with_book_reservation

  private

  def book_must_be_available
    return unless book&.reserved?

    errors.add(:book, "is already reserved")
  end

  def create_with_book_reservation
    ApplicationRecord.transaction do
      yield # Execute reservation save
      book.reserved! # Mark book as reserved
    end
  rescue ActiveRecord::RecordInvalid => e
    # If something goes wrong in the transaction, it will be automatically rolled back
    errors.add(:base, "Failed to create reservation: #{e.message}")
    throw :abort
  end
end
