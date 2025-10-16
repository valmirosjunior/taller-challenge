class BooksController < ApplicationController
  before_action :set_book, only: [:show]

  def index
    books = Book.all
    render json: books, status: :ok
  end

  def show
    render json: @book, status: :ok
  end

  def create
    book = Book.new(book_params)

    if book.save
      render json: book, status: :ok
    else
      render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.permit(:title)
  end
end