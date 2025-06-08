#frozen_string_literal: true

class Role < ApplicationRecord
  ############################################# VALIDATIONS #############################################
  validates :name, presence: true, uniqueness: true

  ############################################# ASSOCIATIONS #############################################
  has_many :users
  has_many :RolePermissions, dependent: :destroy
  has_many :permissions, through: :RolePermissions
  has_many :abilities, through: :permissions
end

# == Schema Information
#
# Table name: roles
#
#  id          :bigint           not null, primary key
#  name        :string           not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_roles_on_name  (name) UNIQUE
#
