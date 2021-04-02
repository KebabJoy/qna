require 'rails_helper'

feature 'User can vote for or against answer', "
  In order to rate an answer
  As a user
  I'd like to be able to vote for answer
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: create(:user)) }


  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    context 'different user', js: true do
      scenario 'upvotes an answer' do
        within "#answer-#{answer.id}" do
          click_on 'Upvote'

          within('.votes-score') { expect(page).to have_content('1') }
        end
      end

      scenario 'vote down an answer' do
        within "#answer-#{answer.id}" do
          click_on 'Vote down'

          within('.votes-score') { expect(page).to have_content('-1') }
        end
      end

      scenario 'Cancel vote' do
        within "#answer-#{answer.id}" do
          click_on 'Upvote'

          click_on 'Cancel vote'
          within('.votes-score') { expect(page).to have_content('0') }
        end
      end
    end

    context 'author' do
      given(:question) { create(:question, author: user) }
      given(:answer) { create(:answer, question: question, author: user) }

      scenario 'tries to vote' do
        visit question_path(question)

        expect(page).to_not have_link('Upvote')
        expect(page).to_not have_link('Vote down')
        expect(page).to_not have_link('Undo vote')
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to vote' do
      visit question_path(question)

      expect(page).to_not have_link('Upvote')
      expect(page).to_not have_link('Down vote')
      expect(page).to_not have_link('Undo vote')
    end
  end
end
