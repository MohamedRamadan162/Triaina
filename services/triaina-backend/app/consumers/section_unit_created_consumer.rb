class SectionUnitCreatedConsumer < ApplicationConsumer
  # This consumer listens to the 'section_unit_created' topic and processes section unit creation events.
  def consume
    messages.each do |msg|
      data = msg.payload["data"]
      section_unit = SectionUnit.find_by(id: data["id"])
      section_unit.generate_transcription if section_unit
      section_unit.generate_summary if section_unit
    end
  end
end
