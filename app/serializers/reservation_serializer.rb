class ReservationSerializer < ActiveModel::Serializer
  attributes :id
  attribute :updated_at, key: :reserved_at

  belongs_to :book, serializer: BookSerializer
  belongs_to :user, serializer: UserSerializer
end
