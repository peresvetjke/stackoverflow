class AnswersChannel < ApplicationCable::Channel
  def subscribed
    reject if params[:question_id].blank?
    stop_all_streams
    stream_from "answers_channel_#{params[:question_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
