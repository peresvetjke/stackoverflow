class AttachmentsController < ApplicationController
  before_action :authenticate_user!, :find_attachment, :find_record

  def destroy
    unless current_user.author_of?(@record)
      return redirect_to @record, notice: "The attachment can be edited only by its author"
    end

    @attachment.purge
  end

  private

  def find_attachment
    @attachment = ActiveStorage::Attachment.find(params[:id])
  end

  def find_record
    @record = instance_eval("#{@attachment.record_type}.find(#{@attachment.record_id})")
  end
  
end