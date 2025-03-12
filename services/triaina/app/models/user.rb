class User < ApplicationRecord
  include Constants
  include Verifiable

  has_one :user_security, dependent: :destroy
  has_many :refresh_tokens, dependent: :destroy

  ######################### Validations #########################
  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 4 }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: EMAIL_REGEX

  ############################ Hooks ############################
  before_validation :sanitize_attributes

  ############################ ٍScopes ##########################
  scope :filter_by_id, ->(id) { where(id: id) }
  scope :filter_by_username, ->(username) { where("username ILIKE ?", "%#{username}%") }
  scope :filter_by_email, ->(email) { where("email ILIKE ?", "%#{email}%") }

  ############################ Methods ##########################
  def is_verified?
    email_verified
  end
end
