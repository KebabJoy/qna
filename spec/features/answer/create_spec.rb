# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', "
  As an authenticated user
  I'd like to be able to ask a question
" do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'creates answer for the question' do
      fill_in 'body', with: 'body'
      click_on 'Create'

      expect(page).to have_content 'Your answer successfully created'
      expect(page).to have_content 'body'
      expect(current_path).to eql(question_path(question))
    end

    scenario 'creates answer for the question with errors' do
      click_on 'Create'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to create answer for the question' do
    visit question_path(question)
    click_on 'Create'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
