class SectionUnitSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :description, :order_index, :section_id

  attribute :content_url do
      object.content.url if object.content.attached? && object.content.blob.service_name == "amazon"
  end
end
