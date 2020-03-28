feature 'My Account Page' do

  feature 'account page' do
    scenario 'button takes the user to their account page', js: true do
      login
      find('.drop-down-container').hover
      find(:xpath, "//a[@href='/myaccount']").click
      expect(page).to have_content 'My Account'
    end
  end

  feature 'my account listings' do
    scenario 'all of users listings shown', js: true do
      login
      add_listing
      find('.drop-down-container').hover
      find(:xpath, "//a[@href='/myaccount']").click
      expect(page).to have_content "Users house"
    end

    scenario 'all of users pending bookings are shown', js: true do
      login
      book_space
      sleep(4)
      find('.drop-down-container').hover
      find(:xpath, "//a[@href='/myaccount']").click
      find(:xpath, "//button[@id='mybookingsbtn']").click
      expect(page).to have_content('Pending Bookings')
      expect(page).to have_content('2020-01-27')
      expect(page).to have_content('2020-02-01')
    end

    scenario 'all of users confirmed bookings are shown', js: true do
      login
      book_space
      sleep(4)
      find('.drop-down-container').hover
      find(:xpath, "//a[@href='/myaccount']").click
      find(:xpath, "//button[@id='mybookingsbtn']").click
      # first(:xpath, "//button[@id='accept-booking']").click
      find('.drop-down-container').hover
      find(:xpath, "//a[@href='/myaccount']").click
      find(:xpath, "//button[@id='mybookingsbtn']").click
      expect(page).to have_content('Confirmed Bookings')
      expect(page).to have_content('2020-01-27')
      expect(page).to have_content('2020-02-01')
    end

    scenario 'all of users pending trips are shown', js: true do
      login
      book_space
      sleep(4)
      find('.drop-down-container').hover
      find(:xpath, "//a[@href='/myaccount']").click
      find(:xpath, "//button[@id='mytripsbtn']").click
      expect(page).to have_content('Pending Trips')
      expect(page).to have_content('2020-01-27')
      expect(page).to have_content('2020-02-01')
    end

    scenario 'all of users confirmed trips are shown', js: true do
      login
      book_space
      sleep(4)
      find('.drop-down-container').hover
      find(:xpath, "//a[@href='/myaccount']").click
      find(:xpath, "//button[@id='mybookingsbtn']").click
      # first(:xpath, "//button[@id='accept-booking']").click
      find('.drop-down-container').hover
      find(:xpath, "//a[@href='/myaccount']").click
      find(:xpath, "//button[@id='mytripsbtn']").click
      expect(page).to have_content('Confirmed Trips')
      expect(page).to have_content('2020-01-27')
      expect(page).to have_content('2020-02-01')
    end
  end

end
