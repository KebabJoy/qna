class NewAnswerNotificationMailer < ApplicationMailer
  def new_answer(author, answer)
    @answer = answer

    mail to: author.email
  end
end
