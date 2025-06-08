class CreatePermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :permissions do |t|
      t.string :action, null: false
      t.string :subject, null: false

      t.index [:action, :subject], unique: true

      t.timestamps
    end
  end
end
