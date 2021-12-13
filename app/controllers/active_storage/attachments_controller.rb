class ActiveStorage::AttachmentsController < ApplicationController
  before_action :authenticate_user!, :find_attachment#, :find_record

  authorize_resource
  
  def destroy
    @attachment.purge
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

  #def find_record
  #  @record = instance_eval("#{@attachment.record_type}.find(#{@attachment.record_id})")
  #end
end