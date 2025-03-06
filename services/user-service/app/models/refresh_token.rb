class RefreshToken < ApplicationRecord
  belongs_to :user, foreign_key: :user_id

  before_validation :generate_token, :set_issued_at, :set_expiration

  validates :user_id, :hashed_token, :issued_at, :expires_at, presence: true

  attr_accessor :raw_token

  def revoke!
    update!(revoked_at: Time.current)
  end

  def expired?
    expires_at <= Time.current
  end

  def revoked?
    revoked_at.present? && revoked_at <= Time.current
  end

  private

  def generate_token
    return if hashed_token.present?

    self.raw_token = SecureRandom.hex(64)
    self.hashed_token = Digest::SHA256.hexdigest(self.raw_token)
    self.raw_token
  end

  def set_issued_at
    self.issued_at ||= Time.current
  end

  def set_expiration
    self.expires_at ||= Time.current + 30.days
  end
end
