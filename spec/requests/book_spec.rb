require 'rails_helper'

RSpec.describe "Books", type: :request do
  describe "GET /books" do
    context "when is successful" do
      context "when there are books" do
        let!(:books) { create_list(:book, 3) }
        
        let(:expected_response) do
          books.map do |book|
            JSON.parse(BookSerializer.new(book).to_json)
          end
        end

        before { get books_path }
        
        include_examples "returns success response"
      end

      context "when there are no books" do
        let(:expected_response) { [] }

        before { get books_path }
        
        include_examples "returns success response"
      end
    end
  end

  describe "GET /books/:id" do
    context "when is successful" do
      let(:book) { create(:book) }
      let(:expected_response) { JSON.parse(BookSerializer.new(book).to_json) }

      before { get book_path(book) }

      include_examples "returns success response"
    end

    context "when is not successful" do
      let(:book_id) { -1 }
      
      before { get book_path(book_id) }
      
      include_examples "returns not found response"
    end
  end

  describe "POST /books" do
    before { post books_path, params: params }

    context "when is successful" do
      let(:params) { { title: "Test Book" } }
      let(:expected_response) { JSON.parse(BookSerializer.new(Book.last).to_json) }

      include_examples "returns success response"
      
      it "creates a book" do
        expect(Book.count).to eq(1)
        expect(Book.last.title).to eq(params[:title])
      end
      
      it "sets book status as available by default" do
        expect(Book.last.status).to eq("available")
      end
    end

    context "when is not successful" do
      context "when title is missing" do
        let(:params) { { title: "" } }
        let(:expected_errors) { [ "Title can't be blank" ] }

        include_examples "returns unprocessable entity response"
        include_examples "does not create record", Book
      end
    end
  end
end
