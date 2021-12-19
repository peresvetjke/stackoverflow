class ApplicationSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  def attachments
    object.files.map { |attachment| url_for(attachment) }
  end
end