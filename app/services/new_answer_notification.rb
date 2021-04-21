class NewAnswerNotification
  def send_new_answer_notification(question, answer)
    NewAnswerNotificationMailer.new_answer(question.author, answer).deliver_later
  end
end

