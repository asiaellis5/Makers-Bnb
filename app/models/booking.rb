require 'date'
class Booking

  attr_reader :booking_id, :confirmation, :start_date, :end_date, :list_name, :user, :price_per_night, :nights, :total_price, :user_id, :img_ref

  def initialize(booking_id, confirmation, start_date, end_date, list_name, username, price_per_night, number_of_nights, total_price, user_id, img_ref)
    @booking_id = booking_id
    @confirmation = (confirmation == 't' ? true : false)
    @start_date = start_date
    @end_date = end_date
    @list_name = list_name
    @user = username
    @price_per_night = price_per_night
    @nights = number_of_nights
    @total_price = total_price
    @user_id = user_id
    @img_ref = img_ref
  end

  def self.setup(dbname)
    @dbconnection = dbname
  end

  def self.create(listing_id:, user_id:, start_date:, end_date:, confirmation: false)
    @dbconnection.command("INSERT INTO bookings(listing_id_fk, user_id_fk, start_date, end_date, confirmation) VALUES('#{listing_id}', '#{user_id}', '#{start_date}', '#{end_date}', false) ;")
  end

  def self.confirm(booking_id:)
    @dbconnection.command("UPDATE bookings SET confirmation = true WHERE booking_id = '#{booking_id}'")
  end

  def self.decline(booking_id:)
    @dbconnection.command("DELETE FROM bookings WHERE booking_id='#{booking_id}';")
  end


  def self.bookings(id)
    bookings = @dbconnection.command("SELECT b.booking_id,  b.start_date, b.end_date, b.confirmation, b.user_id_fk, u.username, l.list_name, l.price_per_night, l.img_ref FROM bookings b JOIN users u ON (b.user_id_fk=u.user_id) JOIN listings l ON (b.listing_id_fk=l.listing_id) WHERE b.listing_id_fk IN (SELECT listing_id FROM listings WHERE user_id_fk='#{id}');")
    self.create_booking_instance(bookings)
  end

  def self.get_blocked_dates_range(listing_id:)
    dates = @dbconnection.command("SELECT start_date, end_date FROM bookings WHERE listing_id_fk='#{listing_id}'")
    booked_dates = dates.map{|booking| (Date.parse(booking['start_date'])..Date.parse(booking['end_date'])).to_a.map{|date| date.to_s}}
    booked_dates.flatten
  end

  def self.trips(id)
    bookings = @dbconnection.command("SELECT b.booking_id,  b.start_date, b.end_date, b.confirmation, l.user_id_fk, u.username, l.list_name, l.price_per_night, l.img_ref FROM bookings b JOIN listings l ON (b.listing_id_fk=l.listing_id) JOIN users u ON (l.user_id_fk=u.user_id) WHERE b.user_id_fk='#{id}';")
    self.create_booking_instance(bookings)
  end

  private

  def self.create_booking_instance(bookings)
    return [] unless bookings
    bookings.map{ |booking|
      nights = number_of_nights(booking['start_date'], booking['end_date'])
      total = nights * booking['price_per_night'].to_i
      self.new(booking['booking_id'], booking['confirmation'], booking['start_date'], booking['end_date'], booking['list_name'], booking['username'], booking['price_per_night'], nights , total, booking['user_id_fk'], booking['img_ref'])
    }
  end

  def self.number_of_nights(start_d, end_d)
    start_date = Date.parse(start_d)
    end_date = Date.parse(end_d)
    (end_date - start_date).to_i
  end
end
