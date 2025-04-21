class Course < ApplicationRecord
  belongs_to :created_by, class_name: "User", foreign_key: "created_by"

  validates :name, presence: true
  validates :join_code, presence: true, uniqueness: true

  # Implement the create_join_code method
  before_validation :create_join_code

  scope :filter_by_id, ->(id) { where(id: id) }
  scope :filter_by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }
  scope :filter_by_created_by, ->(created_by) { where(created_by: created_by) }

  private

  def create_join_code
    self.join_code = loop do
      code = SecureRandom.alphanumeric(8).upcase

      # Ensure the generated code is unique
      break code unless Team.exists?(join_code: code)
    end
  end
end
