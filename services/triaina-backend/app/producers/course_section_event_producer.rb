# frozen_string_literal: true

class CourseSectionEventProducer < ApplicationProducer
  def self.publish_create_section(section)
    publish("course_section_created", section)
  end

  def self.publish_update_section(section)
    publish("course_section_updated", section)
  end

  def self.publish_delete_section(section)
    publish("course_section_deleted", section)
  end
end
