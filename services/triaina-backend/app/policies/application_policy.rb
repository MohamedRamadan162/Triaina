# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record, :controller, :action, :param_id

  def initialize(context, record)
    @user = context[:user]
    @controller = context[:controller]
    @action = context[:action]
    @param_id = context[:param_id]
    @record = record
  end

  def allowed?
    return true if @user.admin?
    user_has_required_ability?
  end

  def user_has_required_ability?
    required_ability = "#{@controller}##{@action}"
    Enrollment.where(user: @user, course: Course.find_by(id: @param_id)).role.abilities.where(name: required_ability).exists?
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  def policy_error_message
    "You are not authorized to access this resource"
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NoMethodError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
