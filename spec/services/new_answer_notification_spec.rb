require 'rails_helper'

RSpec.describe NewAnswerNotification do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:answers) { create_list(:answer, 3, question: question) }


  it 'sends notification about new answer to author of question' do
    answers.each do |answer|
      expect(NewAnswerNotificationMailer).to receive(:new_answer).with(answer.question.author, answer).and_call_original
      subject.send_new_answer_notification(answer.question, answer)
    end
  end
end
