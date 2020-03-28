def login
  visit '/'
  click_button('Log in')
  fill_in("log_in_email", with: 'test-email')
  fill_in("log_in_password", with: 'password')
  click_button 'log in'
end

def add_listing
  find('.drop-down-container').hover
  find(:xpath, "//a[@id='create-listing']").click
  fill_in("list_name", with: "Users house")
  fill_in("short_description", with: "My house is superb!")
  fill_in("price_per_night", with: "150")
  click_button "Add listing"
end

def book_space
  find('.listing > .listing-outline').click
  fill_in("start_date", with: "2020-01-27")
  fill_in("end_date", with: "2020-02-01")
  click_button "Book Space!"
end
