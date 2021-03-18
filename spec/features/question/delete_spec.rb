# frozen_string_literal: true

require 'rails_helper'

feature 'Author can delete his question', "
  As an authenticated user
  I'd like to be able to delete my question
" do

  given(:user) { create(:user) }
  given(:question) { create(:user) }

  scenario 'Authenticated author deletes his question'
  scenario "Authenticated author deletes other's question"
  scenario 'Unauthenticated user deletes a question' do
    visit questions_path

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
