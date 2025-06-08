class CreateChatMessages < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_messages, id: :uuid do |t|
      t.text :content, null: false
      t.uuid :chat_channel_id, null: false
      t.uuid :user_id, null: false
      t.timestamps
    end

    add_foreign_key :chat_messages, :chat_channels, column: :chat_channel_id, primary_key: :id, on_delete: :cascade
    add_foreign_key :chat_messages, :users, column: :user_id, primary_key: :id, on_delete: :cascade
    add_index :chat_messages, :chat_channel_id
    add_index :chat_messages, :user_id
  end
end
