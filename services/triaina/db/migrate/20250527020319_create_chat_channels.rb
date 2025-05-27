class CreateChatChannels < ActiveRecord::Migration[8.0]
  def change
    create_table :chat_channels, id: :uuid do |t|
      t.string :name, null: false
      t.string :description
      t.uuid :course_id, null: false
      t.timestamps
    end

    add_foreign_key :chat_channels, :courses, column: :course_id, primary_key: :id, on_delete: :cascade
    add_index :chat_channels, :course_id
  end
end
