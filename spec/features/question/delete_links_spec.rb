require 'rails_helper'

feature 'Author can delete links attached to his question', "
  In order to delete a link
  As an author
  I'd like to be able to delete a link
" do

  given(:user) { create(:user) }
  given(:user1) { create(:user) }

  given!(:question) do
    create(:question, author: user, links_attributes: [{ name: 'My gist',
                                                         url: 'test.com' }])
  end


  scenario 'author deletes link', js: true do
    sign_in(user)

    visit question_path(question)
    
    expect(page).to have_link 'My gist'

    click_on 'Delete link'

    expect(page).to_not have_link 'My gist'
  end

  scenario 'different user tries to delete a link', js: true do
    sign_in(user1)

    visit question_path(question)

    within '.question .links' do
      expect(page).to_not have_selector("input[type=submit][value='Delete link']")
    end
  end

  scenario 'not authenticated user tries to delete a link', js: true do
    visit question_path(question)

    within '.question .links' do
      expect(page).to_not have_selector("input[type=submit][value='Delete link']")
    end
  end
end
