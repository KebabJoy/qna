# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:votable) }

  let!(:user) { create(:user) }

  describe 'validates user' do
    context 'as author' do
      let(:question) { create(:question, author: user) }

      it 'should raise error if tries to vote' do
        expect { create(:vote, user: user, votable: question) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
    # Похоже, expect() + create сразу создает объект, а expect {} не коммитит. Я прав?
    context 'as different user' do
      let(:question) { create(:question) }

      it "shouldn't raise error if tries to vote" do
        vote = create(:vote, user: create(:user), votable: question)
        expect(vote).to be_valid
      end
    end
  end
end
