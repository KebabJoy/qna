require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:authored_questions).class_name('Question') }
  it { should have_many(:authored_answers).class_name('Answer') }
  it { should have_many(:badges) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:nullify) }
  it { should have_many(:subscriptions).dependent(:destroy) }


  describe 'public instance methods' do
    let(:user) { create(:user) }
    let(:question) { create(:question, author: user) }

    context 'responds to its methods' do
      it { expect(user).to respond_to(:author_of?) }
    end

    context 'executes methods correctly' do
      context '#author_of?' do
        it "does what it's supposed to..." do
          expect(user).to be_author_of(question)
        end
      end
    end
  end
end
