class RenameChatChannels < ActiveRecord::Migration[7.1]
  def change
    rename_table :chat_channels, :course_chats
    rename_column :chat_messages, :chat_channel_id, :course_chat_id

    # Only add index if it doesn't exist
    unless index_exists?(:chat_messages, :course_chat_id)
      add_index :chat_messages, :course_chat_id
    end
  end
end
