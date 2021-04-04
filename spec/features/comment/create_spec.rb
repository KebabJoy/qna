require 'rails_helper'

feature 'User can create the comment', "
  In order to comment a question or an answer
  As an authenticated user
  I'd like to be able to create the comment
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
    end

    scenario 'creates the comment', js: true do
      save_and_open_page
      fill_in 'comment[body]', with: 'text text text'
      click_on 'comment'

      expect(page).to have_content 'text text text'
    end

    scenario 'creates the comment with errors', js: true do
      click_on 'comment'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to create the comment' do
    visit questions_path

    expect(page).to_not have_link 'comment'
  end
end 