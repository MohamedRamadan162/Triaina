class CreateCourseSections < ActiveRecord::Migration[8.0]
  def change
    create_table :course_sections, id: :uuid do |t|
      t.string :title, null: false
      t.string :description
      t.integer :order_index, null: false
      t.uuid :course_id, null: false
      t.timestamps
    end

    add_index :course_sections, :course_id
    add_index :course_sections, [ :course_id, :order_index ], unique: true
  end
end
