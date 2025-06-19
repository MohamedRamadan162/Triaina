# frozen_string_literal: true

namespace :import do
  desc "Import permissions"
  task permissions: :environment do
    puts "Importing permissions"

    permissions = [
      { subject: "course", action: "create" },
      { subject: "course", action: "view" },
      { subject: "course", action: "manage" },
      { subject: "course", action: "list" },
      { subject: "course", action: "list own" },
      { subject: "user", action: "view" },
      { subject: "user", action: "manage" }
    ]

    permissions.each do |attrs|
      Permission.find_or_create_by!(attrs)
    end

    puts "Permissions imported"
  end

  task abilities: :environment do
    puts "Importing abilities"

    abilities = [
      "courses#show",
      "courses#create",
      "courses#index",
      "courses#update",
      "courses#destroy",
      "courses/course_chats#show",
      "courses/course_chats#create",
      "courses/course_chats#index",
      "courses/course_chats#update",
      "courses/course_chats#destroy",
      "courses/course_chats/chat_messages#show",
      "courses/course_chats/chat_messages#create",
      "courses/course_chats/chat_messages#index",
      "courses/course_chats/chat_messages#update",
      "courses/course_chats/chat_messages#destroy",
      "courses/course_sections#show",
      "courses/course_sections#create",
      "courses/course_sections#index",
      "courses/course_sections#update",
      "courses/course_sections#destroy",
      "courses/sections/section_units#show",
      "courses/sections/section_units#create",
      "courses/sections/section_units#index",
      "courses/sections/section_units#update",
      "courses/sections/section_units#destroy",
      "courses/sections/section_units#transcription",
      "courses/sections/section_units#summary"
    ]

    permission = Permission.find_by!(subject: "course", action: "view")
    manage = Permission.find_by!(subject: "course", action: "manage")
    create = Permission.find_by!(subject: "course", action: "create")

    ability_map = abilities.map do |name|
      action = if name.include?("create")
        create
      elsif name.include?("update") || name.include?("destroy")
        manage
      else
        permission
      end

      { name:, permission_id: action.id }
    end

    ability_map.each do |attrs|
      Ability.find_or_create_by!(name: attrs[:name]) do |a|
        a.permission_id = attrs[:permission_id]
      end
    end

    puts "Abilities imported"
  end

  task roles: :environment do
    puts "Creating roles"

    admin = Role.find_or_create_by!(name: "admin")
    admin.permissions = Permission.all

    instructor = Role.find_or_create_by!(name: "instructor")
    instructor.permissions = Permission.where(subject: "course", action: %w[create view manage])

    student = Role.find_or_create_by!(name: "student")
    student.permissions = Permission.where(subject: "course", action: %w[create view])

    puts "Roles created"
  end

  desc "Import all"
  task all: %i[permissions abilities roles]
end
