# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def me?
    allowed? && @user.present? && @user.id == record.id
  end

  def update_me?
    allowed? && @user.present? && @user.id == record.id
  end

  def delete_me?
    allowed? && @user.present? && @user.id == record.id
  end

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
