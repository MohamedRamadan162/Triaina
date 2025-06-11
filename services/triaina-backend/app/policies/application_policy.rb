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
    @user.admin? || normal_user_can_access? || user_has_required_ability?
  end

  def user_has_required_ability?
    return false unless @controller.include?("courses")
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

  def normal_user_can_access?
    normal_user_abilities = ['users/courses#index', 'users#me', 'users#update_me', 'users#delete_me']
    normal_user_abilities.include?("#{@controller}##{@action}") && @user.present?
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
