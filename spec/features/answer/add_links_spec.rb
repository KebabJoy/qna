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

  scenario 'User adds link when creates an answer', js: true do
    sign_in user
    visit question_path(question)

    fill_in 'body', with: 'body'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Create'

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end

end
