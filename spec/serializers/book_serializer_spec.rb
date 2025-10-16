require 'rails_helper'

RSpec.describe BookSerializer, type: :serializer do
  let(:book) { create(:book) }

  it 'serializes book correctly' do
    serialized = JSON.parse(BookSerializer.new(book).to_json)

    expect(serialized).to eq({
      'id' => book.id,
      'title' => book.title,
      'status' => book.status
    })
  end
end
