# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def me?
    @user.present? && @user.id == record.id
  end

  def update_me?
    @user.present? && @user.id == record.id
  end

  def delete_me?
    @user.present? && @user.id == record.id
  end

  def index?
    @user.admin?
  end

  def show?
    @user.admin?
  end

  def create?
    @user.admin?
  end

  def update?
    @user.admin?
  end

  def destroy?
    @user.admin?
  end
end
