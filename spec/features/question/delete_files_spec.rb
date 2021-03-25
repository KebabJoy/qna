require 'rails_helper'

feature 'Author can delete files attached to his question', "
  In order to delete a file
  As an author
  I'd like to be able to delete a file
" do

  given(:user) { create(:user) }
  given(:user1) { create(:user) }

  given!(:question) { create(:question, author: user) }

  scenario 'author deletes attached file', js: true do
    sign_in(user)

    visit questions_path

    within "#question-#{question.id}" do
      click_on 'Edit'

      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
      click_on 'Save'

      expect(page).to have_link 'rails_helper.rb'

      click_on 'Delete file'

      expect(page).to_not have_link 'rails_helper.rb'
    end
  end

  scenario 'different user tries to delete a file', js: true do
    sign_in(user1)

    visit questions_path

    within "#question-#{question.id}" do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'not authenticated user tries to delete a file', js: true do
    visit questions_path

    within "#question-#{question.id}" do
      expect(page).to_not have_link 'Edit'
    end
  end
end
