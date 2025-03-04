class CreateRefreshTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :refresh_tokens, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :hashed_token, null: false
      t.timestamp :issued_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.timestamp :expires_at, null: false, default: -> { "CURRENT_TIMESTAMP + INTERVAL '30 days'" }
      t.timestamp :revoked_at
    end

    add_reference :refresh_tokens, :replaced_by, type: :uuid, foreign_key: { to_table: :refresh_tokens }
  end
end
