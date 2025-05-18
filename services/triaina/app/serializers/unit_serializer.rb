class UnitSerializer < ApplicationSerializer
  attributes :id, :title, :description, :order_index, :section_id
  attribute :content_url do
    if object.content.attached?
      Rails.application.routes.url_helpers.rails_blob_path(object.content, only_path: true)
    else
      nil
    end
  end
end
