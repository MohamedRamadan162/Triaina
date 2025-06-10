class RefreshToken < ApplicationRecord
  belongs_to :user, foreign_key: :user_id

  before_validation :generate_token, :set_issued_at, :set_expiration

  validates :user_id,  :issued_at, :expires_at, presence: true
  validates :hashed_token, uniqueness: { case_sensitive: false }, presence: true

  attr_accessor :raw_token

  scope :valid_tokens, -> { where("expires_at > ?", Time.current) }

  def self.refresh(refresh_token)
    hashed_token = Digest::SHA256.hexdigest(refresh_token)
    refresh_token_record = valid_tokens.find_by(hashed_token: hashed_token)

    return nil unless refresh_token_record
    refresh_token_record.rotate!
  end

  def self.revoke(refresh_token)
    hashed_token = Digest::SHA256.hexdigest(refresh_token)
    refresh_token_record = valid_tokens.find_by(hashed_token: hashed_token)

    return nil unless refresh_token_record
    refresh_token_record.revoke!
  end

  def rotate!
    transaction do
      revoke!
      new_refresh_token = RefreshToken.create!(user: user)

      {
        user: user,
        new_jwt: JsonWebToken.encode(user_id: user.id),
        new_refresh_token: new_refresh_token.raw_token
      }
    end
  end

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
