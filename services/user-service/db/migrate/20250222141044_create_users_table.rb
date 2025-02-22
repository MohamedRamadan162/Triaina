class CreateUsersTable < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: false do |t|
      t.uuid :user_id, primary_key: true
      t.string :username, null: false, unique: true
      t.string :name, null: false
      t.string :email, null: false, unique: true
      t.boolean :email_verified
      t.string :avatar_url
      t.timestamp :deleted_at
      t.timestamps
    end
  end
end
