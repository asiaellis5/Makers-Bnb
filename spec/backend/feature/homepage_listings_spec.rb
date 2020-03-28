feature 'Homepage Listings' do

  feature "showings listings" do
    scenario "it shows listings on the homepage" do
      visit('/')
      expect(page).to have_content 'Test listing 1'
      expect(page).to have_content 'test'
    end
  end

end
