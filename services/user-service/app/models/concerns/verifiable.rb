# frozen_string_literal: true

module Verifiable
  include ActiveSupport::Concern

  def sanitize_attributes
    self.email = email.strip.downcase if email.present?
    self.name = name.strip if name.present?
    self.username = username.strip if username.present?
  end
end
