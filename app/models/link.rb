require 'uri'

class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :title, :url, presence: true
  validate :validate_url

  private

  def validate_url
    self.errors.add :url, message: "has wrong format" unless valid_url?(self.url)
  end

  def valid_url?(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end


end
