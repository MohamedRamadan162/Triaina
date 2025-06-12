class Course::CourseChat::ChatMessagePolicy < ApplicationPolicy
  def index?
    allowed?
  end

  def show?
    allowed?
  end

  def create?
    allowed?
  end

  def update?
    allowed?
  end

  def destroy?
    allowed?
  end
end
