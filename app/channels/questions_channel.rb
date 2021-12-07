class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "questions"
  end
  
  def follow
    stop_all_streams
    stream_from "questions"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
