class ApplicationSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  def attachments
    object.files.map { |attachment| url_for(attachment) }
  end

  def author_email
    object.author.email
  end
end