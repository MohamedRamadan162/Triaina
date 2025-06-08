class ChatMessageSerializer < ApplicationSerializer
  attributes :id, :content, :created_at, :updated_at

  attribute :user do
    {
      id: object.user.id,
      username: object.user.username,
      name: object.user.name
    }
  end
end
