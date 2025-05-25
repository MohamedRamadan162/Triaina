# frozen_string_literal: true

module Constants
  KAFKA_EVENT_VERSION = "1.0"
  PASSWORD_REGEX = /\A(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}\z/
  EMAIL_REGEX = /\A[^@\s]+@[^@\s]+\z/
end
