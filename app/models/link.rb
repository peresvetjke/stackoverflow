require 'uri'

class Link < ApplicationRecord
  
  GIST_HOST = 'gist.github.com'

  belongs_to :linkable, polymorphic: true, touch: true

  validates :title, :url, presence: true
  validate  :validate_url

  def gist?
    uri = URI.parse(url)
    uri.host == GIST_HOST
  end

  def gist_id
    URI(url).path.split('/').last
  end

  private

  def validate_url
    errors.add :url, message: "has wrong format" unless valid_url?(self.url)
  end

  def valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end
end
