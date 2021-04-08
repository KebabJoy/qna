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

    scenario 'creates answer for the question', js: true do
      fill_in 'body', with: 'body'
      click_on 'Create'

      expect(current_path).to eql(question_path(question))
      within '.answers' do
        expect(page).to have_content 'body'
      end
    end

    scenario 'answers the question with attached file', js: true do
      fill_in 'body', with: 'body'

      attach_file 'Files', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
      click_on 'Create'

      within '.answers' do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'creates answer for the question with errors', js: true do
      click_on 'Create'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to create answer for the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Create'
  end
end
