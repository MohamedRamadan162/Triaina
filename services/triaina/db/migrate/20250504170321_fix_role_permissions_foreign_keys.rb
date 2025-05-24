class FixRolePermissionsForeignKeys < ActiveRecord::Migration[8.0]
  def change
    change_table :role_permissions do |t|
      # First remove the string columns
      t.remove :roles
      t.remove :permissions
      
      # Add the proper foreign key columns
      t.references :role, null: false, foreign_key: true
      t.references :permission, null: false, foreign_key: true
    end
    
    # Add a unique index to prevent duplicate assignments
    add_index :role_permissions, [:permission_id, :role_id], unique: true
  end
end 