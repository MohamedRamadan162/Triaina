class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses, id: :uuid do |t|
      t.string :name, null: false
      t.string :description
      t.string :join_code, null: false, limit: 10
      t.uuid :created_by, null: false
      t.timestamp :start_date, null: false
      t.timestamp :end_date
      t.timestamps
    end

    add_foreign_key :courses, :users, column: :created_by, on_delete: :cascade

    add_index :courses, :join_code, unique: true
  end
end
