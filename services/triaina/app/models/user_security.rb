class UserSecurity < ApplicationRecord
  include Constants

  self.primary_key = :user_id
  has_secure_password

  ######################### Associations #########################
  belongs_to :user, foreign_key: :user_id
  has_many :refresh_tokens, foreign_key: :user_id, dependent: :destroy

  ######################### Validations #########################
  validates :password, presence: true, format: { with: PASSWORD_REGEX, message: "Password must contain at least 8 characters, including one uppercase letter, one lowercase letter, one number and one special character" }
end
