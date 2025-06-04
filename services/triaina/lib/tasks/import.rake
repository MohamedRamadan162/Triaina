#frozen_string_literal: true

namespace :import do
  desc "Import permissions"
  task permissions: :environment do
    p 'Destroying old permissions'
    Permission.destroy_all
    p 'Old permissions destroyed'

    p 'Importing permissions'
    Permission.create([
      { subject: 'course', action: 'create' },
      { subject: 'course', action: 'view' },
      { subject: 'course', action: 'manage' },
      { subject: 'course', action: 'list' },
      { subject: 'course', action: 'list own' },
      { subject: 'user', action: 'view' },
      { subject: 'user', action: 'manage' },
    ])
    p 'Permissions imported'
  end

  task abilities: :environment do
    p 'Destroying old abilities'
    Ability.destroy_all
    p 'Old abilities destroyed'

    p 'Importing abilities'
    Ability.create([
      { name: 'course#show', permission: Permission.find_by(subject: 'course', action: 'view') },
      { name: 'course#create', permission: Permission.find_by(subject: 'course', action: 'create') },
      { name: 'course#index', permission: Permission.find_by(subject: 'course', action: 'list') },
      { name: 'course#update', permission: Permission.find_by(subject: 'course', action: 'manage') },
      { name: 'course#destroy', permission: Permission.find_by(subject: 'course', action: 'manage') },
      { name: 'users/courses#index', permission: Permission.find_by(subject: 'course', action: 'list_own') },
      { name: 'user#show', permission: Permission.find_by(subject: 'user', action: 'view') },
      { name: 'user#update', permission: Permission.find_by(subject: 'user', action: 'manage') },
      { name: 'user#destroy', permission: Permission.find_by(subject: 'user', action: 'manage') },
    ])
    p 'Abilities imported'
  end

  task roles: :environment do
    p 'Creating roles'
    Role.create([
      { name: 'admin', permissions: Permission.all },
      { name: 'instructor', permissions: Permission.where(
        '(subject = ? AND action IN (?)) OR (subject = ? AND action IN (?))',
        'course', ['create', 'view', 'manage', 'list_own'],
        'user', ['view']
      )},
      { name: 'student', permissions: Permission.where(
        '(subject = ? AND action IN (?)) OR (subject = ? AND action IN (?))',
        'course', ['create', 'view', 'list_own'],
        'user', ['view']
      )},
    ])
    p 'Roles created'
  end
end
