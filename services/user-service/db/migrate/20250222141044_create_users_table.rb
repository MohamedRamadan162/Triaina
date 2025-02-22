class CreateUsersTable < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: false do |t|
      t.uuid :user_id, primary_key: true
      t.string :username, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.boolean :email_verified
      t.string :avatar_url
      t.timestamp :deleted_at
      t.timestamps
    end

    # Unique constraints
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
