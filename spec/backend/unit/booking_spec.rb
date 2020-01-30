require 'booking'
describe Booking do

  let(:subject){ Booking }

  before(:each) do
    @user_id = DatabaseConnection.command("SELECT user_id FROM users;")[0]['user_id']
    @listing_id = DatabaseConnection.command("SELECT listing_id FROM listings;")[0]['listing_id']
  end

  describe '.create' do
    it 'adds a booking request into the database' do
      subject.create(listing_id: @listing_id, user_id: @user_id, start_date:'2020-07-08', end_date:'2020-07-10')
      expect(subject.bookings(@user_id)[-1].start_date).to eq '2020-07-08'
      expect(subject.bookings(@user_id)[-1].end_date).to eq '2020-07-10'
    end
  end

  describe ".confirm" do
    it "changes the booking confirmation from false to true" do
      booking_id = DatabaseConnection.command("SELECT listing_id_fk FROM bookings WHERE confirmation='f'")[0]['listing_id_fk']
      subject.confirm(booking_id: booking_id)
      expect(subject.bookings(@user_id)[0].confirmation).to eq true
    end
  end

  describe '.bookings' do
    it 'returns pending bookings for a user' do
      bookings = subject.bookings(@user_id)
      bookings.reject!{|booking| booking.confirmation == true}
      expect(bookings[0]).to be_a(Booking)
      expect(bookings[0].list_name).to eq('Test listing 1')
      expect(bookings[0].confirmation).to eq(false)
    end
    it 'returns confirmed bookings for a user' do
      bookings = subject.bookings(@user_id)
      bookings.reject!{|booking| booking.confirmation == false}
      expect(bookings[0]).to be_a(Booking)
      expect(bookings[0].list_name).to eq('Test listing 1')
      expect(bookings[0].confirmation).to eq(true)
    end
    it 'returns empty array if no bookings' do
      bookings = subject.bookings(1000000)
      expect(bookings).to eq([])
    end
  end
end
