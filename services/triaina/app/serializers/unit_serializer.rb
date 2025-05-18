class UnitSerializer < ApplicationSerializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :description, :order_index, :section_id

  attribute :content_url do
    if object.content.attached?
      blob = object.content.blob

      # Direct AWS S3 presigned URL generation
      s3_client = Aws::S3::Client.new(
        region: ENV["AWS_REGION"] || Rails.application.credentials.dig(:aws, :region),
        access_key_id: ENV["AWS_ACCESS_KEY_ID"] || Rails.application.credentials.dig(:aws, :access_key_id),
        secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"] || Rails.application.credentials.dig(:aws, :secret_access_key)
      )

      bucket_name = ENV["AWS_BUCKET_NAME"] || Rails.application.credentials.dig(:aws, :bucket)

      signer = Aws::S3::Presigner.new(client: s3_client)

      signer.presigned_url(
        :get_object,
        bucket: bucket_name,
        key: blob.key,
        expires_in: 3600 * 3,
        response_content_type: blob.content_type
      )
    else
      nil
    end
  end
end
