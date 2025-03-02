class ApiController < ApplicationController
  # Add pagination metadata
  after_action { pagy_headers_merge(@pagy) if @pagy }

  # cattr :current_user

  # # Policies
  # def pundit_user
  #   @current_user
  # end

  # List and filter records
  def list(model, filtering_params: filtering_params(), multiselection_filtering_params: multiselection_filtering_params(), ordering_params: ordering_params())
    records = model.filter_by(filtering_params, multiselection_filtering_params).order_by(ordering_params)
    @pagy, records = pagy(records) unless params[:page].to_i == -1
    records
  end

  # Create session
  # def sessions
  #   @session ||= SessionsManager
  # end

  def filtering_params
    []
  end

  def multiselection_filtering_params
    []
  end

  def ordering_params
    { order_by_created_at: :desc }
  end

  def serializer(objects, params: {}, serializer_class: serializer_class())
  serializer_class.render(objects, params)
  end

  def controller_model
    controller_name.classify.constantize
  end

  def serializer_class
    "#{controller_model}Serializer".constantize
  end
end
