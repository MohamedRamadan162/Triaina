class User < ApplicationRecord
  self.table_name = "user_service.users"
  validates :user_id, presence: true
  validates :username, presence: true
  validates :name, presence: true
  validates :email, presence: true
end
