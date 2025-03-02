# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  ################### Custom Error Subclasses ####################

  included do
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
    rescue_from ActiveModel::StrictValidationFailed, with: :general_bad_request
    rescue_from ActionController::ParameterMissing, with: :general_bad_request

    rescue_from ActiveRecord::RecordNotDestroyed do |err|
      render(
        json: { success: false, message: err.record.errors.full_messages.join(' ') },
        status: :not_found
      )
    end

    # Catch database exceptions
    rescue_from ActiveRecord::StatementInvalid do |err|
      render(
        json: { success: false, message: I18n.t(:db_error, reason: err) },
        status: :bad_request
      )
    end

    # Catch pagination key exception
    rescue_from Pagy::VariableError do |_err|
      render(
        json: { success: false, message: I18n.t(:invalid_pagination) },
        status: :not_found
      )
    end
  end
end
