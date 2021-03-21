require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to(:author).with_foreign_key(:author_id) }

  it { should validate_presence_of :body }

  describe 'public instance methods' do
    let(:user) { create(:user) }
    let(:answer) { create(:answer, question: create(:question), author: user) }

    context 'responds to its methods' do
      it { expect(answer).to respond_to(:best!) }
    end

    context 'executes methods correctly' do
      context '#best!' do
        it "does what it's supposed to..." do
          expect(answer.best).to eq(false)

          answer.best!

          expect(answer.best).to eq(true)
        end
      end
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
