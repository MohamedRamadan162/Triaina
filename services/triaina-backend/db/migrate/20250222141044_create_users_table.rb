class CreateUsersTable < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :username, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.boolean :email_verified, null: false, default: false
      t.timestamps
    end

    # Unique constraints
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
