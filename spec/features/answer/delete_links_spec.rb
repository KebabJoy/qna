require 'rails_helper'

feature 'Author can delete links attached to his answer', "
  In order to delete a link
  As an author
  I'd like to be able to delete a link
" do

  given(:user) { create(:user) }
  given(:user1) { create(:user) }

  given!(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given(:gist_url) { 'https://gist.github.com/KebabJoy/4b62871a905938b11b9d6cb421e48a8f' }


  scenario 'author deletes link', js: true do
    sign_in(user)

    visit question_path(question)

    within "#answer-#{answer.id}" do
      click_on 'Edit'
      click_on 'add link'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
      click_on 'Save'

      expect(page).to have_link 'My gist'

      click_on 'Delete link'

      expect(page).to_not have_link 'My gist'
    end
  end

  scenario 'different user tries to delete a link', js: true do
    sign_in(user1)

    visit question_path(question)

    within "#answer-#{answer.id}" do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'not authenticated user tries to delete a link', js: true do
    visit question_path(question)

    within "#answer-#{answer.id}" do
      expect(page).to_not have_link 'Edit'
    end
  end
end
