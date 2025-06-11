class User::CoursePolicy < ApplicationPolicy
  def index?
    allowed?
  end

  class Scope < Scope
    def resolve
      user.courses
    end
  end
end
