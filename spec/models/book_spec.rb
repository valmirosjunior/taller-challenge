require 'rails_helper'

RSpec.describe Book, type: :model do
  it { should have_many(:reservations) }
  it { should have_many(:users).through(:reservations) }
  
  it { should validate_presence_of(:title) }

  describe 'status enum' do
    it 'defines the correct enum values' do
      expect(Book.statuses).to eq({ 'available' => 'available', 'reserved' => 'reserved' })
    end

    it 'has available status by default' do
      book = Book.new(title: 'Test Book')
      expect(book.status).to eq('available')
    end

    it 'allows changing status' do
      book = Book.create!(title: 'Test Book')
      expect(book.available?).to be true
      
      book.reserved!
      expect(book.reserved?).to be true
      expect(book.available?).to be false
      
      book.available!
      expect(book.available?).to be true
      expect(book.reserved?).to be false
    end
  end
end
