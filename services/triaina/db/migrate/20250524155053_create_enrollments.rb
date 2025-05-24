class CreateEnrollments < ActiveRecord::Migration[8.0]
  def change
    create_table :enrollments do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :course, null: false, foreign_key: true, type: :uuid
      t.references :role, null: false, foreign_key: true
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    # Add a unique index to prevent duplicate enrollments
    add_index :enrollments, [:user_id, :course_id], unique: true
  end
end 