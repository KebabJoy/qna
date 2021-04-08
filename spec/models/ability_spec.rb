require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:authored_question) { create(:question, author: user) }
    let(:not_authored_question) { create(:question, author: other) }
    let(:authored_answer) { create(:answer, author: user) }
    let(:not_authored_answer) { create(:answer, author: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, authored_question }
    it { should_not be_able_to :update, not_authored_question }

    it { should be_able_to :update, authored_answer }
    it { should_not be_able_to :update, not_authored_answer }

    it { should be_able_to :destroy, authored_question }
    it { should_not be_able_to :destroy, not_authored_question }

    it { should be_able_to :destroy, authored_answer }
    it { should_not be_able_to :destroy, not_authored_answer }

    context 'vote answer' do
      it { should_not be_able_to :vote_for, authored_answer }
      it { should be_able_to :vote_for, not_authored_answer }

      it { should_not be_able_to :vote_against, authored_answer }
      it { should be_able_to :vote_against, not_authored_answer }

      it { should_not be_able_to :cancel_vote, authored_answer }
      it { should be_able_to :cancel_vote, not_authored_answer }
    end

    context 'vote question' do
      it { should_not be_able_to :vote_for, authored_question }
      it { should be_able_to :vote_for, not_authored_question }

      it { should_not be_able_to :vote_against, authored_question }
      it { should be_able_to :vote_against, not_authored_question }

      it { should_not be_able_to :cancel_vote, authored_question }
      it { should be_able_to :cancel_vote, not_authored_question }
    end

    it { should be_able_to :make_best, create(:answer, question: authored_question, author: other) }
    it { should_not be_able_to :make_best, create(:answer, question: not_authored_question, author: other) }

    it { should be_able_to :destroy, create(:link, linkable: authored_question) }
    it { should be_able_to :destroy, create(:link, linkable: authored_answer) }

    it { should_not be_able_to :destroy, create(:link, linkable: not_authored_answer) }
    it { should_not be_able_to :destroy, create(:link, linkable: not_authored_answer) }

  end
end
