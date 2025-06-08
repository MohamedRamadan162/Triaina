class SectionUnitSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :description, :order_index, :section_id

  attribute :content_url do
      object.content.url if object.content.attached? && !ActiveStorage::Blob.service.is_a?(ActiveStorage::Service::DiskService)
  end
end
