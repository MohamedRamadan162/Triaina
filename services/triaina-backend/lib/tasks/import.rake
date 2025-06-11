# frozen_string_literal: true

namespace :import do
  desc "Import permissions"
  task permissions: :environment do
    p "Destroying old permissions"
    Permission.destroy_all
    p "Old permissions destroyed"

    p "Importing permissions"
    Permission.create([
      { subject: "course", action: "create" },
      { subject: "course", action: "view" },
      { subject: "course", action: "manage" },
      { subject: "course", action: "list" },
      { subject: "course", action: "list own" },
      { subject: "user", action: "view" },
      { subject: "user", action: "manage" }
    ])
    p "Permissions imported"
  end

  task abilities: :environment do
    p "Destroying old abilities"
    Ability.destroy_all
    p "Old abilities destroyed"

    p "Importing abilities"
    Ability.create([
      { name: "courses#show", permission: Permission.find_by(subject: "course", action: "view") },
      { name: "courses#create", permission: Permission.find_by(subject: "course", action: "create") },
      { name: "courses#index", permission: Permission.find_by(subject: "course", action: "list") },
      { name: "courses#update", permission: Permission.find_by(subject: "course", action: "manage") },
      { name: "courses#destroy", permission: Permission.find_by(subject: "course", action: "manage") }
    ])
    p "Abilities imported"
  end

  task roles: :environment do
    p "Creating roles"
    Role.create([
      { name: "admin", permissions: Permission.all },
      { name: "instructor", permissions: Permission.where(
        "(subject = ? AND action IN (?))",
        "course", [ "create", "view", "manage" ],
      ) },
      { name: "student", permissions: Permission.where(
        "(subject = ? AND action IN (?))",
        "course", [ "create", "view" ],
      ) }
    ])
    p "Roles created"
  end

  desc "Import all"
  task all: %i[permissions abilities roles]
end
