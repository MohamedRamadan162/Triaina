# frozen_string_literal: true

class CourseSectionEventProducer < ApplicationProducer
  def self.publish_create_section(section)
    publish("course_section.created", section)
  end

  def self.publish_update_section(section)
    publish("course_section.updated", section)
  end

  def self.publish_delete_section(section)
    publish("course_section.deleted", section)
  end
end
