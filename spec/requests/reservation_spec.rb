require 'rails_helper'

RSpec.describe "Reservations", type: :request do
  describe "GET /book/reservations" do
    context "when is successful" do
      let(:book)  { create(:book) }
      let!(:reservations) { create_list(:reservation, reservations_count, book: book) }

      before do
        get book_reservations_path(book)
      end

      context "when there are reservations" do
        let(:reservations_count) { 2 }

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "returns an array of reservations" do
          expect(response.parsed_body.size).to eq(reservations_count)
        end

        it "returns valid JSON response with serialized data" do
          expected_response = reservations.map do |reservation|
            JSON.parse(ReservationSerializer.new(reservation).to_json)
          end

          expect(response.parsed_body).to eq(expected_response)
        end
      end

      context "when there are no reservations" do
        let(:reservations_count) { 0 }

        it "returns http success" do
          expect(response).to have_http_status(:success)
        end

        it "returns empty array" do
          expect(response.parsed_body).to eq([])
        end
      end
    end

    context "when is not successful" do
      before do
        get book_reservations_path(book)
      end

      context "when book does not exist" do
        let(:book)  { build(:book, id: -1) }      
        let(:params) { {} }

        it "returns not found status" do
          expect(response).to have_http_status(:not_found)
        end

        it "does not create a reservation" do
          expect(Reservation.count).to eq(0)
        end
      end
    end
  end

  describe "GET /book/reserve/:id" do
    before do
      get book_reservation_path(book, reservation)
    end

    context "when is successful" do
      let!(:reservation) { create(:reservation, book: book) }
      let(:book) { create(:book) }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "returns valid JSON response with serialized data" do
        expected_response = JSON.parse(ReservationSerializer.new(reservation).to_json)
        expect(response.parsed_body).to eq(expected_response)
      end
    end

    context "when is not successful" do
      let(:reservation) { build(:reservation, id: -1) }

      context "when reservation does not exist" do
        let(:book) { create(:book) }

        it "returns not found status" do
          expect(response).to have_http_status(:not_found)
        end
      end

      context "when book does not exist" do
        let(:book) { build(:book, id: -1) }

        it "returns not found status" do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end

  describe "POST /book/reserve" do
    before do
      post book_reserve_path(book), params: params
    end

    context "when is successful" do
      let(:book)  { create(:book) }      
      let(:user)  { create(:user) }
      let(:params) do
        {
          user_email: user.email
        }
      end
      let(:last_reservation) { Reservation.last }
      let(:expected_response) { JSON.parse(ReservationSerializer.new(last_reservation).to_json) }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end

      it "creates a reservation" do
        expect(Reservation.count).to eq(1)
        
        expect(last_reservation.book).to eq(book)
        expect(last_reservation.user).to eq(user)
      end

      it "updates the book status to reserved" do
        expect(book.reload.status).to eq("reserved")
      end

      it "returns valid JSON response" do
        expect(response.parsed_body).to eq(expected_response)
      end
    end

    context "when is not successful" do
      context "when the book is already reserved" do
        let(:book)  { create(:book, status: "reserved") }      
        let(:user)  { create(:user) }
        let(:params) do
          {
            user_email: user.email
          }
        end

        it "returns unprocessable entity status" do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "does not create a reservation" do
          expect(Reservation.count).to eq(0)
        end

        it "returns error message" do
          expect(response.parsed_body).to eq({ "error" => "Book is already reserved" })
        end
      end

      context "when the user does not exist" do
        let(:book)  { create(:book) }      
        let(:params) do
          {
            user_email: "non_existent_user@example.com"
          }
        end

        it "returns not found status" do
          expect(response).to have_http_status(:not_found)
        end

        it "does not create a reservation" do
          expect(Reservation.count).to eq(0)
        end
      end

      context "when book does not exist" do
        let(:book)  { build(:book, id: -1) }      
        let(:params) { {} }

        it "returns not found status" do
          expect(response).to have_http_status(:not_found)
        end

        it "does not create a reservation" do
          expect(Reservation.count).to eq(0)
        end
      end
    end
  end
end
