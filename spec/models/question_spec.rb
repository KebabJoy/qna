require 'rails_helper'
require Rails.root.join 'spec/models/concerns/votable_spec.rb'

RSpec.describe Question, type: :model do
  it_behaves_like 'votable'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_one(:badge).dependent(:destroy) }
  
  it { should belong_to(:author).with_foreign_key(:author_id) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create_list(:answer, 33, question: question, author: user) }


  it 'has many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#has_best_answer?!' do
    it 'shows if question has best answer' do
      expect(question.has_best_answer?).to eq false

      create(:answer, best: true, question: question, author: user)

      expect(question.has_best_answer?).to eq true
    end
  end
end
