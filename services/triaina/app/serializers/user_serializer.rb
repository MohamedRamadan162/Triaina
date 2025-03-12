class UserSerializer < ApplicationSerializer
  attributes :id, :username, :name, :email, :created_at, :updated_at

  attribute :verified do
    object.is_verified?
  end
end
