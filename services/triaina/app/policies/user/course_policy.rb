class User::CoursesPolicy < ApplicationPolicy
  def index?
    @user.present?
  end

  class Scope < Scope
    def resolve
      user.courses
    end
  end
end
