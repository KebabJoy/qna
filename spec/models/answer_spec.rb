require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to(:author).with_foreign_key(:author_id) }

  it { should validate_presence_of :body }

  it 'has many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should accept_nested_attributes_for :links }

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, author: user) }
  let(:best_answer) { create(:answer, question: question, author: user, best: true) }
  let!(:badge) { create(:badge, question: question) }


  describe '#best!' do
    it 'makes an answer best and removes another best answer' do
      expect(answer.best).to eq(false)
      expect(best_answer.best).to eq(true)

      answer.best!

      expect(answer.best).to eq(true)

      best_answer.reload
      expect(best_answer.best).to eq(false)
    end
  end

  describe 'default scopes' do
    it 'orders by descending best value' do
      question = create(:question)
      answer1 = create(:answer, question: question)
      answer2 = create(:answer, best: true, question: question)

      expect(Answer.all).to_not eq [answer1, answer2]
      expect(Answer.all).to eq [answer2, answer1]
    end
  end
end
