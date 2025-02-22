class User < ApplicationRecord
  self.table_name = "user_service.users"

  before_validation :normalizeInput

  validates :username, presence: true, uniqueness: true, length: { minimum: 4 }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: {
    with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email format"
  }

  private
  def normalizeInput
    self.email = email.strip.downcase if email.present?
    self.name = name.strip if name.present?
  end
end
