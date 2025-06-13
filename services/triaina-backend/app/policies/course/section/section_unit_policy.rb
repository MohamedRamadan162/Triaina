class Course::Section::SectionUnitPolicy < ApplicationPolicy
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

  def transcription?
    allowed?
  end

  def summary?
    allowed?
  end
end
