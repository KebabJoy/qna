require 'rails_helper'

shared_examples_for 'votable' do
  let(:user) { create(:user) }
  let(:model) { create(described_class.name.downcase.to_sym, author: user) }
  let(:user2) { create(:user) }

  it { should have_many(:votes).dependent(:destroy) }

  describe '#votes_sum' do
    it 'shows difference between votes' do
      votes = create_list(:vote, 33, value: 1, votable: model, user: user2)
      expect(model.votes_sum).to eq 33
    end
  end

  describe '#upvote' do
    context 'author' do
      it 'does not change number of votes' do
        expect { model.upvote(user) }.to_not change(Vote, :count)
      end
    end

    context 'different user' do
      it 'changes number of votes' do
        expect { model.upvote(user2) }.to change(Vote, :count).by(1)
      end
    end
  end

  describe '#vote_down' do
    context 'author' do
      it 'does not change number of votes' do
        expect { model.vote_down(user) }.to_not change(Vote, :count)
      end
    end

    context 'different user' do
      it 'changes number of votes' do
        expect { model.vote_down(user2) }.to change(Vote, :count)
      end
    end
  end

  describe '#undo_vote' do
    it 'deletes your vote' do
      model.upvote(user2)
      expect { model.undo_vote(user2) }.to change(Vote, :count)
    end
  end
end
