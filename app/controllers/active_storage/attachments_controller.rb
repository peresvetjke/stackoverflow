class ActiveStorage::AttachmentsController < ApplicationController
  before_action :find_attachment
  authorize_resource
  before_action :authenticate_user!
    
  respond_to :js

  def destroy
    @attachment.purge
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end
end