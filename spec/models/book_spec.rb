require 'rails_helper'

RSpec.describe Book, type: :model do
  it { should have_many(:reservations) }
  it { should have_many(:users).through(:reservations) }
  
  it { should validate_presence_of(:title) }
  it { should validate_inclusion_of(:status).in_array(%w[available reserved]) }  
end
