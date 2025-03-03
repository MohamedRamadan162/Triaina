class CreateSchema < ActiveRecord::Migration[8.0]
  def up
    execute 'CREATE SCHEMA IF NOT EXISTS user_service'
  end

  # Reverse migration if needed (CREATE SCHEMA is not reversible)
  def down
    execute 'DROP SCHEMA IF EXISTS user_service CASCADE'
  end
end
