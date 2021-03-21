require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my answer
" do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }

  scenario 'Unauthenticated cannot edit answer', js: true do
    visit question_path(question)

    expect(page).to_not have_selector("input[type=submit][value='Edit']")
  end

  describe 'Authenticated user' do
    context 'as author' do
      background do
        sign_in user
        visit question_path(question)

        click_on 'Edit'
      end

      scenario 'edits his answer', js: true do
        expect(page).to have_css('input[type="text"]')

        within '.answers' do
          fill_in 'Your answer', with: 'edited answer'
          click_on 'Save'

          expect(page).to_not have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).to_not have_css('input[type="text"]')
        end
      end

      scenario 'edits his answer with errors', js: true do
        within '.answers' do
          fill_in 'answer[body]', with: ''
          click_on 'Save'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's question", js: true do
      sign_in user2
      visit question_path(question)

      expect(page).to_not have_link 'Edit'
    end

  end


end
