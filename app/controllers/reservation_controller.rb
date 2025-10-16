class ReservationController < ApplicationController
  before_action :set_book, only: [:index, :show, :create]
  before_action :set_user, only: [:create]
  before_action :set_reservation, only: [:show]

  def index
    reservations = @book.reservations.includes(:user)

    render json: reservations, status: :ok
  end

  def show
    render json: @reservation, status: :ok
  end

  def create
    reservation = @book.reservations.build(user: @user)

    if reservation.save
      render json: reservation, status: :ok
    else
      render json: { errors: reservation.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def set_reservation
    @reservation = @book.reservations.find(params[:id])
  end

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
