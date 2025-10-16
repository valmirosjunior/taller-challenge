class ReservationSerializer < ActiveModel::Serializer
  attribute :updated_at, key: :reserved_at

  belongs_to :book, serializer: BookSerializer
  belongs_to :user, serializer: UserSerializer
end
