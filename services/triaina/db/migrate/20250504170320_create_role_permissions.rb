class CreateRolePermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :role_permissions do |t|
      t.string :roles
      t.string :permissions

      t.timestamps
    end
  end
end
