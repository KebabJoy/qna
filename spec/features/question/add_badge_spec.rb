# frozen_string_literal: true

require 'rails_helper'

feature 'User can add badge to question', "
  In order to provide award user for best answer
  As an question's author
  I'd like to be able to add badge
" do

  given(:user) { create(:user) }
  given(:img_url) { 'https://www.pngkey.com/png/full/17-175787_red-seal-badge-transparent-png-clip-art-banner.png' }

  context 'User adds valid badge when asks question' do
    background do
      sign_in user
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Badge name', with: 'Best answer'
    end

    scenario 'with valid image url' do
      fill_in 'Img url', with: img_url

      click_on 'Ask'

      expect(page).to have_content 'Best answer'
      expect(page).to have_css('#badge')
    end

    scenario 'User adds invalid image url when asks question' do
      fill_in 'Img url', with: 'something'

      click_on 'Ask'

      expect(page).to_not have_content 'Best answer'
      expect(page).to_not have_css('#badge')
    end
  end
end
