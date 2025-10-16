class ReservationController < ApplicationController
  before_action :set_book, :set_user, only: [:create]

  def create
    if @book.status == "reserved"
      render json: { error: "Book is already reserved" }, status: :unprocessable_entity
      return
    end

    @book.status = "reserved"
    @book.save!
    reservation = Reservation.new(book: @book, user: @user)

    if reservation.save
      render json: reservation, status: :ok
    else
      render json: { errors: reservation.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def set_book
    @book = Book.find(params[:book_id])
  end
  
  def set_user
    @user = User.find_by!(email: reservation_params[:user_email])
  end

  def reservation_params
    params.permit(:user_email)
  end  
end
