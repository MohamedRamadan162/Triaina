class UserSecurity < ApplicationRecord
  include Constants

  self.primary_key = :user_id
  belongs_to :user, foreign_key: :user_id

  has_secure_password

  validates :password, presence: true, format: { with: PASSWORD_REGEX }, if: -> { password.present? }
end
