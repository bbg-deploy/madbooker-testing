class Gen
  
class << self
  
  def method_missing name, *args
    #save ! methods automatically
    if name.to_s =~ /!$/
      obj = send name.to_s.chop, *args
      obj.save!
      return obj
    end
    super and return 
  end
  
  def hotel overrides = {}
    defaults = {
      :name                  => Faker::Name.name,
      :url                   => Faker::Internet.url,
      :phone                 => Faker::PhoneNumber.phone_number,
      :fax                   => Faker::PhoneNumber.phone_number,
      :room_rates_display    => [1,2].sample,
      :subdomain             => Faker::Internet.domain_word,
      :address               => Faker::Address.street_address,
      :google_analytics_code => Faker::Name.name,
      :fine_print            => Faker::Lorem.paragraphs(5).join 
    }
    make Hotel, defaults, overrides
  end

  def room_type args = {}
    defaults = {
      number_of_rooms: (18..125).to_a.sample,
      name:            Faker::Internet.domain_word,
      default_rate:    (50..120).to_a.sample,
      discounted_rate: nil,
      description:     Faker::Lorem.sentences.join
    }
    make RoomType, defaults, args
  end
  
  def inventory args = {}
    defaults = {
      :available_rooms => (18..54).to_a.sample,
      :sales_count  => 0,
      :rate            => (50..120).to_a.sample,
      :discounted_rate => nil,
      :date            => Date.today,
      :room_type_id    => 1
    }
    make Inventory, defaults, args 
  end
  
  
  def booking args = {}
    defaults = {
      :hotel_id           => 1,
      :room_type_id       => 1,
      :arrive             => Date.today,
      :depart             => Date.today,
      :rate               => (50..120).to_a.sample,
      :discounted_rate    => 0,
      :first_name         => Faker::Name.first_name,
      :last_name          => Faker::Name.last_name,
      :made_by_first_name => Faker::Name.first_name,
      :made_by_last_name  => Faker::Name.last_name,
      :email              => Faker::Internet.email,
      :email_confirmation => Faker::Internet.email,
      :sms_confirmation   => Faker::PhoneNumber.cell_phone,
      :cc_number          => "4242424242424242",
      :cc_month           => Date.today.month+1,
      :cc_year            => Date.today.year+1,
      :cc_cvv             => "123",
      :cc_zipcode         => Faker::Address.zip,
      :guid               => UUIDTools::UUID.random_create.to_s.gsub("-", "")
    }
    make Booking, defaults, args 
  end

  def sale args = {}
    defaults = {
      :inventory_id    => 1,
      :booking_id      => 1,
      :hotel_id        => 1,
      :rate            => (50..120).to_a.sample,
      :discounted_rate => 0,
      :date            => Date.today,
    }
    make Sale, defaults, args 
  end
  
  def booking_list args = {}
    avail = (18..54).to_a.sample
    booked = (18..avail).to_a.sample
    methods = {
      room_type: Gen.room_type,
      available: avail,
      booked: booked,
      percent_booked: booked.to_d/avail * 100,
      rooms: [Gen.booking, Gen.booking]
    }.merge args
    OpenStruct.new methods
  end
  
  def package args = {}
    defaults = {
      :hotel_id        => 1,
      :room_type_id    => 1,
      :rate            => (50..120).to_a.sample,
      :discounted_rate => nil,
      :active          => true
    }
    make Package, defaults, args     
  end
  
  def add_on args = {}
    defaults = {
      :hotel_id     => 1,
      :name         => Faker::Internet.domain_word,
      :description  => Faker::Lorem.sentences.join,
      :price        => (50..120).to_a.sample
    }
    make AddOn, defaults, args
  end
  
  def user args = {}
    defaults = {
      :email     => Faker::Internet.email,
      :time_zone => "UTC"
    }
    make User, defaults, args
  end
  
  
  private
  def make cla, args, overrides
    cla.new args.merge(overrides)
  end
end

end

