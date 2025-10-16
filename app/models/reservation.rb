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
      yield # Executa o salvamento da reserva
      book.reserved! # Marca o livro como reservado
    end
  rescue ActiveRecord::RecordInvalid => e
    # Se algo der errado na transação, ela será revertida automaticamente
    errors.add(:base, "Failed to create reservation: #{e.message}")
    throw :abort
  end
end
