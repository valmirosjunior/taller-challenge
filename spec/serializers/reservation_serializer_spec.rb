require 'rails_helper'

RSpec.describe ReservationSerializer, type: :serializer do
  let(:user) { create(:user) }
  let(:book) { create(:book) }
  let(:reservation) { create(:reservation, user: user, book: book) }

  it 'serializes reservation with associations correctly' do
    serialized = JSON.parse(ReservationSerializer.new(reservation).to_json)

    expected_book = JSON.parse(BookSerializer.new(book).to_json)
    expected_user = JSON.parse(UserSerializer.new(user).to_json)

    expect(serialized).to eq({
      'id' => reservation.id,
      'reserved_at' => reservation.updated_at.as_json,
      'book' => expected_book,
      'user' => expected_user
    })
  end
end
