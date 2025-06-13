class SectionUnit < ApplicationRecord
  has_one_attached :content
  has_one_attached :transcription
  has_one_attached :summary

  ######################### Associations #########################
  belongs_to :course_section, class_name: "CourseSection", foreign_key: "section_id"

  ########################## Validations #########################
  validates :title, presence: true
  validates :order_index, presence: true, uniqueness: { scope: :section_id }

  ############################ Hooks ############################
  before_validation :create_order_index

  ############################### Scopes ############################
  scope :filter_by_id, ->(id) { where(id: id) }
  scope :filter_by_section_id, ->(section_id) { where(section_id: section_id) }
  scope :filter_by_section_and_order, ->(section_id, order_index) {
    where(section_id: section_id, order_index: order_index)
  }

  def generate_transcription
    return if content.blank?
    return unless content.attached? && (content.content_type.start_with?("video/") || content.content_type.start_with?("audio/"))
    return if transcription.attached?

    audio_file = nil
    tempfile = nil

    begin
      audio_file = Ffmpeg.extract_audio(content)
      ai_service = GroqService.new
      transcription_body = ai_service.transcribe(audio_file)

      tempfile = Tempfile.new([ "#{File.basename(content.filename.to_s, '.*')}_transcription_#{Time.now.strftime('%Y%m%d%H%M%S')}", ".json" ], binmode: true)
      tempfile.write(transcription_body)
      tempfile.rewind

      transcription.attach(
        io: tempfile,
        filename: "#{File.basename(content.filename.to_s, '.*')}.json",
        content_type: "application/json"
      )
    ensure
      audio_file.close! if audio_file.respond_to?(:close!)
      tempfile.close! if tempfile.respond_to?(:close!)
    end
  end

  def generate_summary
    return if transcription.blank?
    return unless transcription.attached? && transcription.content_type == "application/json"
    return if summary.attached?

    begin
      ai_service = GroqService.new
      json_content = transcription.download
      parsed = JSON.parse(json_content)
      transcript_text = parsed["text"] || parsed.dig("segments")&.map { |s| s["text"] }&.join(" ")
      summary_body = ai_service.summarize(transcript_text)

      tempfile = Tempfile.new([ "#{File.basename(transcription.filename.to_s, '.*')}_summary_#{Time.now.strftime('%Y%m%d%H%M%S')}", ".md" ], binmode: true)
      tempfile.write(summary_body)
      tempfile.rewind

      summary.attach(
        io: tempfile,
        filename: "#{File.basename(transcription.filename.to_s, '.*')}_summary.json",
        content_type: "application/json"
      )
    ensure
      tempfile.close! if tempfile.respond_to?(:close!)
    end
  end

  private

  def create_order_index
    return if self.order_index.present?
    max_index = SectionUnit.where(section_id: self.section_id).maximum(:order_index) || 0
    self.order_index = max_index + 1
  end
end
