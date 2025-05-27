class Course < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: "created_by"
  has_many :course_sections, dependent: :destroy
  has_many :chat_channels, dependent: :destroy
  has_many :section_units, through: :course_sections

  validates :name, presence: true
  validates :join_code, presence: true, uniqueness: true

  before_validation :create_join_code

  scope :filter_by_id, ->(id) { where(id: id) }
  scope :filter_by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }
  scope :filter_by_created_by, ->(created_by) { where(created_by: created_by) }

  private

  def create_join_code
    return if self.join_code.present?

    self.join_code = loop do
      code = SecureRandom.alphanumeric(8).upcase
      # Ensure the generated code is unique
      break code unless Course.exists?(join_code: code)
    end
  end
end
