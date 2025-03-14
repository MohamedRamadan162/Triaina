module TestConstants
  DEFAULT_NAME="John Doe"
  DEFAULT_USERNAME="johndoe"
  DEFAULT_EMAIL="johndoe@email.com"
  DEFAULT_PASSWORD="SecurePass123!"
  HASHED_DEFAULT_PASSWORD=BCrypt::Password.create(DEFAULT_PASSWORD)
end