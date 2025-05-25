module TestConstants
  DEFAULT_API_VERSION = "v1"
  DEFAULT_API_BASE_URL = "/api/#{DEFAULT_API_VERSION}"

  DEFAULT_USER = {
    name: "John Doe",
    username: "johndoe",
    email: "johndoe@email.com",
    password: "SecurePass123!"
  }
  # DEFAULT_NAME="John Doe"
  # DEFAULT_USERNAME="johndoe"
  # DEFAULT_EMAIL="johndoe@email.com"
  # DEFAULT_PASSWORD="SecurePass123!"
  # HASHED_DEFAULT_PASSWORD=BCrypt::Password.create(DEFAULT_PASSWORD)
end
