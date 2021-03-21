# frozen_string_literal: true

require 'rails_helper'

feature 'Author can delete his answer', "
  As an authenticated user
  I'd like to be able to delete my answer
" do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }


  scenario 'Authenticated user deletes his answer', js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_content answer.body
    click_on 'Delete Answer'

    expect(page).to_not have_content answer.body
  end

  scenario "Authenticated user deletes other's answer" do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_selector("input[type=submit][value='Delete Answer']")
  end

  scenario 'Unauthenticated user deletes an answer' do
    visit question_path(question)

    expect(page).to_not have_selector("input[type=submit][value='Delete Answer']")
  end
end
