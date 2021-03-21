# frozen_string_literal: true

require 'rails_helper'

feature 'User can choose the best answer', "
  As an author of the question
  I'd like to be able to choose the best answer
" do

  given!(:user) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given!(:answers) { create_list(:answer, 33, question: question, author: user)}
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:best_answer) { create(:answer, question: question, author: user, best: true) }

  describe 'Authenticated user' do
    context 'as author' do
      background do
        sign_in user

        visit question_path(question)
      end

      scenario 'chooses the best answer', js: true do
        expect(page).to have_selector("input[type=submit][value='Choose as Best']")


        within "#answer-#{answer.id}" do
          click_on 'Choose as Best'
        end

        within find('.answers', match: :first) do
          expect(page).to have_content answer.body
        end
      end

      scenario 'chooses the best answer when the best is taken', js: true do
        within find('.answers', match: :first) do
          expect(page).to have_content best_answer.body
        end

        within "#answer-#{answer.id}" do
          click_on 'Choose as Best'
        end

        within find('.answers', match: :first) do
          expect(page).to have_content answer.body
        end
      end
    end

    scenario 'as different user tries to choose the best answer' do
      sign_in user2

      visit question_path(question)

      expect(page).to_not have_selector("input[type=submit][value='Choose as Best']")
    end
  end

  scenario 'Unauthenticated user tries to choose the best answer' do
    visit question_path(question)

    expect(page).to_not have_selector("input[type=submit][value='Choose as Best']")
  end
end
