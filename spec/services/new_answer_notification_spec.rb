require 'rails_helper'

RSpec.describe NewAnswerNotification do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, author: user) }
  let!(:ans_author) { create(:user) }
  let!(:answer) { create(:answer, author: ans_author, question: question) }


  it 'sends notification about new answer to author of question' do
    expect(NewAnswerNotificationMailer).to receive(:new_answer).with(user, answer).and_call_original
    subject.send_new_answer_notification(question, answer)
  end
end
