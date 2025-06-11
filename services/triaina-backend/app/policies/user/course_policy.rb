class User::CoursePolicy < ApplicationPolicy
  def index?
    @user.present?
  end

  class Scope < Scope
    def resolve
      user.courses
    end
  end
end
