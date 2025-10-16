require 'rails_helper'

RSpec.describe Reservation, type: :model do
  it { should belong_to(:book) }
  it { should belong_to(:user) }

  let(:user) { create(:user) }
  let(:book) { create(:book) }

  describe 'creating a reservation' do
    context 'when book is available' do
      it 'creates reservation and marks book as reserved' do
        expect(book.available?).to be true

        reservation = Reservation.create(book: book, user: user)

        expect(reservation).to be_valid
        expect(reservation.persisted?).to be true
        expect(book.reload.reserved?).to be true
      end
    end

    context 'when book is already reserved' do
      before { book.reserved! }

      it 'fails validation and does not create reservation' do
        reservation = Reservation.new(book: book, user: user)

        expect(reservation).to be_invalid
        expect(reservation.errors[:book]).to include("is already reserved")
        expect(reservation.persisted?).to be false
      end
    end

    context 'when reservation fails to save for other reasons' do
      it 'rolls back book status' do
        # Simulate user validation failure
        allow_any_instance_of(User).to receive(:valid?).and_return(false)

        expect(book.available?).to be true

        reservation = Reservation.create(book: book, user: nil)

        expect(reservation.persisted?).to be false
        expect(book.reload.available?).to be true
      end
    end
  end
end
