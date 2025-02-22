class User < ApplicationRecord
  self.table_name = "user_service.users"
  validates :user_id, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
