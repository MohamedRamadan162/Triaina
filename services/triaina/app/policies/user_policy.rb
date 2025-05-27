# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    true
  end

  def destroy?
    true
  end

  def enrolled?
    true
  end

  class Scope < Scope
    def initialize(user, scope)
      super
      @courses = user.courses
    end

    def resolve
      @courses
    end
  end
end
