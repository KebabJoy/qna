# frozen_string_literal: true

require 'rails_helper'

feature 'Author can delete his question', "
  As an authenticated user
  I'd like to be able to delete my question
" do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user) }


  scenario 'Authenticated user deletes his question' do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content question.title
    click_on 'Delete Question'

    expect(page).to_not have_content question.title
  end

  scenario "Authenticated user deletes other's question" do
    sign_in(user2)
    visit question_path(question)

    click_on 'Delete Question'

    expect(page).to have_content 'Only author can delete his questions'
  end

  scenario 'Unauthenticated user deletes a question' do
    visit question_path(question)
    click_on 'Delete Question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
