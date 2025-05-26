# frozen_string_literal: true

class SectionUnitEventProducer < ApplicationProducer
  def self.publish_create_unit(unit)
    publish("section_unit.created", unit)
  end

  def self.publish_update_unit(unit)
    publish("section_unit.updated", unit)
  end

  def self.publish_delete_unit(unit)
    publish("section_unit.deleted", unit)
  end
end
