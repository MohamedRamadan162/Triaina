# frozen_string_literal: true

class UserSecurity < ApplicationRecord
  self.primary_key = :user_id

  has_secure_password :hashed_password

  validates :user_id, presence: true, uniqueness: true
  validates :password, presence: true, format: {
    with: /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}\z/,
    message: 'must be at least 8 characters long and include 1 uppercase, 1 lowercase, 1 number, and 1 special character'
  }, if: -> { password.present? }
end
