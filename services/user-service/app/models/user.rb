class User < ApplicationRecord
  include Constants
  include Verifiable

  ######################### Validations #########################
  validates :username, presence: true, uniqueness: true, length: { minimum: 4 }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: EMAIL_REGEX, if: -> { email.present? }

  ############################ Hooks ############################
  before_validation :sanitize_attributes

  ############################ Methods ##########################
  def is_verified?
    email_verified
  end
end
