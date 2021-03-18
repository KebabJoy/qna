# frozen_string_literal: true

require 'rails_helper'

feature 'User can log out', "
  As signed in user
  I'd like to be able to logout app
" do

  given(:user) { create(:user) }

  background { sign_in(user) }

  scenario 'User tries to log out' do
    visit(root_path)
    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
