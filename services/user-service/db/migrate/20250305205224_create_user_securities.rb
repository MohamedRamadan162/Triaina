class CreateUserSecurities < ActiveRecord::Migration[8.0]
  def change
    create_table :user_securities, id: false do |t|
      t.uuid :user_id, primary_key: true
      t.string :password_digest, null: false
      t.timestamp :password_updated_at
      t.timestamps
    end

    add_foreign_key :user_securities, :users, column: :user_id
  end
end
