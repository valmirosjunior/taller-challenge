require 'rails_helper'

RSpec.describe "Users", type: :request do
  before { User.delete_all }
  
  describe "GET /users" do
    context "when is successful" do
      context "when there are users" do
        let!(:users) { create_list(:user, 3) }
        
        let(:expected_response) do
          users.map do |user|
            JSON.parse(UserSerializer.new(user).to_json)
          end
        end

        before { get users_path }
        
        include_examples "returns success response"
      end

      context "when there are no users" do
        let(:expected_response) { [] }

        before { get users_path }
        
        include_examples "returns success response"
      end
    end
  end

  describe "GET /users/:id" do
    context "when is successful" do
      let(:user) { create(:user) }
      let(:expected_response) { JSON.parse(UserSerializer.new(user).to_json) }

      before { get user_path(user) }

      include_examples "returns success response"
    end

    context "when is not successful" do
      let(:user_id) { -1 }
      
      before { get user_path(user_id) }
      
      include_examples "returns not found response"
    end
  end

  describe "POST /users" do
    context "when is successful" do
      let(:email) { "user_email@example.com" }
      let(:params) { { email: email } }
      let(:expected_response) { JSON.parse(UserSerializer.new(User.last).to_json) }

      before { post users_path, params: params }

      include_examples "returns success response"
      
      it "creates a user" do
        expect(User.count).to eq(1)
        expect(User.last.email).to eq(params[:email])
      end
    end

    context "when is not successful" do
      context "when email is missing" do
        let(:params) { {} }
        let(:expected_errors) { [ "Email can't be blank" ] }

        before { post users_path, params: params }

        include_examples "returns unprocessable entity response"
        
        it "does not create a user" do
          expect(User.count).to eq(0)
        end
      end

      context "when email is already taken" do
        let(:existing_email) { user.email }
        let(:user) { create(:user) }
        let(:expected_errors) { [ "Email has already been taken" ] }
        
        before do          
          post users_path, params: { email: existing_email }
        end

        include_examples "returns unprocessable entity response"
        
        it "does not create a new user" do
          expect(User.where(email: existing_email).count).to eq(1)
        end
      end
    end
  end
end