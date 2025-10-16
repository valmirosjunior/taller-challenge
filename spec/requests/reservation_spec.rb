require 'rails_helper'

RSpec.describe "Reservations", type: :request do
  # Shared contexts específicos de reservations
  shared_context "with non-existent book" do
    let(:book) { build(:book, id: -1) }
    let(:params) { {} }
  end

  shared_context "with non-existent reservation" do
    let(:reservation) { build(:reservation, id: -1) }
  end

  describe "GET /book/reservations" do
    context "when is successful" do
      let(:book) { create(:book) }

      context "when there are reservations" do
        let!(:reservations) do
          first_reservation = create(:reservation, book: book)
          book.available! # simulates a returned book
          second_reservation = create(:reservation, book: book)
          [first_reservation, second_reservation]
        end

        let(:expected_response) do
          reservations.map do |reservation|
            JSON.parse(ReservationSerializer.new(reservation).to_json)
          end
        end

        before { get book_reservations_path(book) }

        include_examples "returns success response"
      end

      context "when there are no reservations" do
        let(:expected_response) { [] }

        before { get book_reservations_path(book) }

        include_examples "returns success response"
      end
    end

    context "when is not successful" do
      include_context "with non-existent book"
      
      before { get book_reservations_path(book) }
      
      include_examples "returns not found response"
      include_examples "does not create record", Reservation
    end
  end

  describe "GET /book/reserve/:id" do
    context "when is successful" do
      let(:book) { create(:book) }
      let!(:reservation) { create(:reservation, book: book) }
      let(:expected_response) { JSON.parse(ReservationSerializer.new(reservation).to_json) }

      before { get book_reservation_path(book, reservation) }

      include_examples "returns success response"
    end

    context "when is not successful" do
      before { get book_reservation_path(book, reservation) }

      context "when reservation does not exist" do
        include_context "with non-existent reservation"
        let(:book) { create(:book) }

        include_examples "returns not found response"
      end

      context "when book does not exist" do
        include_context "with non-existent book"
        include_context "with non-existent reservation"

        include_examples "returns not found response"
      end
    end
  end

  describe "POST /book/reserve" do
    before { post book_reserve_path(book), params: params }

    context "when is successful" do
      let(:book) { create(:book) }
      let(:user) { create(:user) }
      let(:params) { { user_email: user.email } }
      let(:expected_response) { JSON.parse(ReservationSerializer.new(Reservation.last).to_json) }

      include_examples "returns success response"
      
      it "creates a reservation" do
        expect(Reservation.count).to eq(1)
        expect(Reservation.last.book).to eq(book)
        expect(Reservation.last.user).to eq(user)
      end
      
      it "updates book status to reserved" do
        expect(book.reload.status).to eq("reserved")
      end
    end

    context "when is not successful" do
      context "when the book is already reserved" do
        let(:book) { create(:book, status: "reserved") }
        let(:user) { create(:user) }
        let(:params) { { user_email: user.email } }
        let(:expected_errors) { [ "Book is already reserved" ] }

        include_examples "returns unprocessable entity response"
        include_examples "does not create record", Reservation
      end

      context "when the user does not exist" do
        let(:book) { create(:book) }
        let(:params) { { user_email: "non_existent_user@example.com" } }

        include_examples "returns not found response"
        include_examples "does not create record", Reservation
      end

      context "when book does not exist" do
        include_context "with non-existent book"

        include_examples "returns not found response"
        include_examples "does not create record", Reservation
      end
    end
  end
end
