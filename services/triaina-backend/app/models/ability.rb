class Ability < ApplicationRecord
  #################### Associations ####################
  belongs_to :permission
  
  #################### Validations ####################
  validates :name, presence: true
end

# == Schema Information
#
# Table name: abilities
#
#  id            :bigint           not null, primary key
#  name          :string           not null
#  permission_id :bigint           not null
#
# Indexes
#
#  index_abilities_on_name_and_permission_id  (name,permission_id) UNIQUE
#
