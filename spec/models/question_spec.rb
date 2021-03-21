require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:author).with_foreign_key(:author_id) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe 'public instance methods' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }
    let(:answer) { create_list(:answer, 33, question: question, author: user) }

    context 'responds to its methods' do
      it { expect(question).to respond_to(:has_best_answer?) }
      it { expect(question).to respond_to(:remove_best_answer) }
    end

    context 'executes methods correctly' do
      context '#has_best_answer?!' do
        it "does what it's supposed to..." do
          expect(question.has_best_answer?).to eq false

          create(:answer, best: true, question: question, author: user)

          expect(question.has_best_answer?).to eq true
        end
      end

      context '#remove_best_answer' do
        it "does what it's supposed to" do
          create(:answer, best: true, question: question, author: user)

          expect(question.has_best_answer?).to eq true

          question.remove_best_answer

          expect(question.has_best_answer?).to eq false
        end
      end
    end
  end
end
