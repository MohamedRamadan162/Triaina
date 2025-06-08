#frozen_string_literal: true

class Permission < ApplicationRecord
  ######################### Validations #########################
  validates :action, presence: true
  validates :subject, presence: true

  ######################### Associations #########################
  has_many :role_permissions, dependent: :destroy
  has_many :roles, through: :role_permissions
  has_many :abilities, dependent: :destroy
end

# == Schema Information
#
# Table name: permissions
#
#  id         :bigint           not null, primary key
#  action     :string           not null
#  subject    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_permissions_on_action_and_subject  (action,subject) UNIQUE
#