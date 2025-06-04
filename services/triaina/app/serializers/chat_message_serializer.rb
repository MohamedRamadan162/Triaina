class ChatMessageSerializer < ApplicationSerializer
  attributes :id, :content, :created_at, :updated_at

  attribute :user do
    UserSerializer.render(object.user)
  end
end
