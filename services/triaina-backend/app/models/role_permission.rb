#frozen_string_literal: true

class RolePermission < ApplicationRecord
  ############################################# ASSOCIATIONS #############################################
  belongs_to :role
  belongs_to :permission
end

# == Schema Information
#
# Table name: role_permissions
#
#  id            :bigint           not null, primary key
#  role_id       :bigint           not null
#  permission_id :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_role_permissions_on_permission_id_and_role_id  (permission_id,role_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (permission_id => permissions.id)
#  fk_rails_...  (role_id => roles.id)
#