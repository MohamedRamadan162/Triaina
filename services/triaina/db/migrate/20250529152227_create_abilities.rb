class CreateAbilities < ActiveRecord::Migration[8.0]
  def change
    create_table :abilities do |t|
      t.string :name
      t.references :permission, null: false, foreign_key: true

      t.timestamps
    end

    add_index :abilities, [:name, :permission_id], unique: true
  end
end
