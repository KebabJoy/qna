require 'rails_helper'

feature 'User can vote for or against questions', "
  In order to rate a question
  As a user
  I'd like to be able to vote for questions
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: create(:user)) }


  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
    end

    context 'author' do
      given(:question) { create(:question, author: user) }

      scenario 'tries to vote' do
        expect(page).to_not have_link('Upvote')
        expect(page).to_not have_link('Vote down')
        expect(page).to_not have_link('Undo vote')
      end
    end

    context 'different user', js: true do
      scenario 'upvotes a question' do
        within "#question-#{question.id}" do
          click_on 'Upvote'

          within('.votes-score') { expect(page).to have_content('1') }
        end
      end

      scenario 'vote down a question' do
        within "#question-#{question.id}" do
          click_on 'Vote down'
          within('.votes-score') { expect(page).to have_content('-1') }
        end
      end

      scenario 'Cancel vote' do
        within "#question-#{question.id}" do
          click_on 'Upvote'

          click_on 'Cancel vote'
          within('.votes-score') { expect(page).to have_content('0') }
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'tries to vote' do
      visit questions_path

      expect(page).to_not have_link('Upvote')
      expect(page).to_not have_link('Down vote')
      expect(page).to_not have_link('Undo vote')
    end
  end
end
