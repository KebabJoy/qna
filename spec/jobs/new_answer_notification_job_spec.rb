require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:service) { double('NewAnswerNotification') }
  let(:question) { create(:question, author: create(:user)) }
  let(:answer) { create(:answer, question: question) }


  before do
    allow(NewAnswerNotification).to receive(:new).and_return(service)
  end

  it 'calls NewAnswerNotification#send_new_answer_notification' do
    expect(service).to receive(:send_new_answer_notification)
    NewAnswerNotificationJob.perform_now(question, answer)
  end
end
