class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(question, answer)
    NewAnswerNotification.new.send_new_answer_notification(question, answer)
  end
end
