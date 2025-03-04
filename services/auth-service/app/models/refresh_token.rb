class RefreshToken < ApplicationRecord
  validates :user_id, :hashed_token, :issued_at, :expires_at, presence: true

  before_create :set_issued_at, :set_expiration

  def expired?
    expires_at <= Time.current
  end

  # TODO: implement revocation and replacement with another token

  private

  def set_issued_at
    self.issued_at ||= Time.current
  end

  def set_expiration
    self.expired_at ||= Time.current + 30.days
  end
end
