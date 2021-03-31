# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/KebabJoy/4b62871a905938b11b9d6cb421e48a8f' }

  context 'User adds link when creates an answer' do
    background do
      sign_in user
      visit question_path(question)

      fill_in 'body', with: 'body'
      fill_in 'Link name', with: 'My gist'
    end

    scenario 'with valid url', js: true do
      fill_in 'Url', with: gist_url

      click_on 'Create'

      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
      end
    end

    scenario 'with invalid url', js: true do
      fill_in 'Url', with: 'not a link'

      click_on 'Create'

      expect(page).to_not have_link 'My gist', href: 'not a link'
      expect(page).to have_content 'Links url is invalid'
    end
  end
end
