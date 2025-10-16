require 'rails_helper'

RSpec.describe UserSerializer, type: :serializer do
  let(:user) { create(:user) }

  it 'serializes user correctly' do
    serialized = JSON.parse(UserSerializer.new(user).to_json)

    expect(serialized).to eq({ 'email' => user.email })
  end
end
