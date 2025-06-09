# frozen_string_literal: true

class CourseEventProducer < ApplicationProducer
  def self.publish_create_course(course)
    publish("course_created", course)
  end

  def self.publish_update_course(course)
    publish("course_updated", course)
  end

  def self.publish_delete_course(course)
    publish("course_deleted", course)
  end
end
