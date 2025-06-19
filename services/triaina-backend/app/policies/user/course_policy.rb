class User::CoursePolicy < ApplicationPolicy
  def index?
    allowed?
  end

  class Scope < Scope
    def initialize(context, scope)
      super
    end

    def resolve
      @user.courses
    end
  end
end
