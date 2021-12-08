class CommentsChannel < ApplicationCable::Channel
  def subscribed
    reject if params[:question_id].blank?
    stream_from "questions/#{params[:question_id]}/comments"
  end

  def follow
    stop_all_streams
    stream_from "questions/#{params[:question_id]}/comments"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
