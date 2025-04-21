class CreateSectionUnits < ActiveRecord::Migration[8.0]
  def change
    create_table :section_units, id: :uuid do |t|
      t.string :title, null: false
      t.string :description
      t.integer :order_index, null: false
      t.string :content_url, null: false
      t.uuid :section_id, null: false
      t.timestamps
    end

    add_index :section_units, :section_id
    add_index :section_units, [ :section_id, :order_index ], unique: true

    add_foreign_key :section_units, :course_sections, column: :section_id, primary_key: :id, on_delete: :cascade
  end
end
