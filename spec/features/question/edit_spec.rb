# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author 
  I'd like to be able to edit my question
" do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Unauthenticated cannot edit question', js: true do
    visit questions_path

    expect(page).to_not have_selector("input[type=submit][value='Edit']")
  end

  describe 'Authenticated user' do
    context 'as author' do
      background do
        sign_in user
        visit questions_path

        click_on 'Edit'
      end

      scenario 'edits his question', js: true do
        expect(page).to have_css('input[type="text"]')

        within '.questions' do
          fill_in 'Your question', with: 'edited question'
          click_on 'Save'

          expect(page).to_not have_content question.body
          expect(page).to have_content 'edited question'
          expect(page).to_not have_css('input[type="text"]')
        end
      end

      scenario 'edits his question with errors', js: true do
        within '.questions' do
          fill_in 'question[body]', with: ''
          click_on 'Save'
        end

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's question", js: true do
      sign_in user2
      visit questions_path

      expect(page).to_not have_link 'Edit'
    end

  end


end
