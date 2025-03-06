class CreateRefreshTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :refresh_tokens, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :hashed_token, null: false
      t.timestamp :issued_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :expires_at, null: false, default: -> { "CURRENT_TIMESTAMP + INTERVAL '30 days'" }
      t.timestamp :revoked_at
      t.uuid :replaced_by
    end

    add_foreign_key :refresh_tokens, :users, column: :user_id
    add_foreign_key :refresh_tokens, :refresh_tokens, column: :replaced_by

    add_index :refresh_tokens, :user_id
  end
end
