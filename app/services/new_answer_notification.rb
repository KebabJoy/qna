class NewAnswerNotification
  def send_new_answer_notification(question, answer)
    question.subscriptions.each do |subscription|
      NewAnswerNotificationMailer.new_answer(subscription.user, answer).deliver_later
    end
  end
end

