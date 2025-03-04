class CreateUserSecurities < ActiveRecord::Migration[8.0]
  def change
    create_table :user_securities, id: false do |t|
      t.uuid :user_id, primary_key: true
      t.string :hashed_password, null: false
      t.timestamps
    end
  end
end
