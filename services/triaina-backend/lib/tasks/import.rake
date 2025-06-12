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
      { name: "courses#destroy", permission: Permission.find_by(subject: "course", action: "manage") },
      { name: "courses/course_chats#show", permission: Permission.find_by(subject: "course", action: "view") },
      { name: "courses/course_chats#create", permission: Permission.find_by(subject: "course", action: "create") },
      { name: "courses/course_chats#index", permission: Permission.find_by(subject: "course", action: "view") },
      { name: "courses/course_chats#update", permission: Permission.find_by(subject: "course", action: "manage") },
      { name: "courses/course_chats#destroy", permission: Permission.find_by(subject: "course", action: "manage") },
      { name: "courses/course_chats/chat_messages#show", permission: Permission.find_by(subject: "course", action: "view") },
      { name: "courses/course_chats/chat_messages#create", permission: Permission.find_by(subject: "course", action: "create") },
      { name: "courses/course_chats/chat_messages#index", permission: Permission.find_by(subject: "course", action: "view") },
      { name: "courses/course_chats/chat_messages#update", permission: Permission.find_by(subject: "course", action: "manage") },
      { name: "courses/course_chats/chat_messages#destroy", permission: Permission.find_by(subject: "course", action: "manage") },
      { name: "courses/course_sections#show", permission: Permission.find_by(subject: "course", action: "view") },
      { name: "courses/course_sections#create", permission: Permission.find_by(subject: "course", action: "create") },
      { name: "courses/course_sections#index", permission: Permission.find_by(subject: "course", action: "view") },
      { name: "courses/course_sections#update", permission: Permission.find_by(subject: "course", action: "manage") },
      { name: "courses/course_sections#destroy", permission: Permission.find_by(subject: "course", action: "manage") },
      { name: "courses/sections/section_units#show", permission: Permission.find_by(subject: "course", action: "view") },
      { name: "courses/sections/section_units#create", permission: Permission.find_by(subject: "course", action: "create") },
      { name: "courses/sections/section_units#index", permission: Permission.find_by(subject: "course", action: "view") },
      { name: "courses/sections/section_units#update", permission: Permission.find_by(subject: "course", action: "manage") },
      { name: "courses/sections/section_units#destroy", permission: Permission.find_by(subject: "course", action: "manage") }
    ])
    p "Abilities imported"
  end

  task roles: :environment do
    p "Destroying old roles"
    Role.destroy_all
    p "Old roles destroyed"

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
