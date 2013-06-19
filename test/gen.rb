class Gen
  
class << self
  
  def method_missing name, *args
    super and return unless name.to_s =~ /!$/
    obj = send name.to_s.chop, *args
    obj.save!
    obj
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

  def room_type overrides = {}
    defaults = {
      number_of_rooms: (18..125).to_a.sample,
      name:            Faker::Internet.domain_word,
      default_rate:    (50..120).to_a.sample,
      discounted_rate: 0,
      description:     Faker::Lorem.sentences.join
    }
    make RoomType, defaults, overrides
  end
  
  def inventory args = {}
    defaults = {
      
      :available_rooms => (18..54).to_a.sample,
      :bookings_count  => 0,
      :rate            => (50..120).to_a.sample,
      :discounted_rate => 0,
      :date            => Date.today,
      :room_type_id    => 1
    }
    make Inventory, defaults, args 
  end
  
  private
  def make cla, args, overrides
    cla.new args.merge(overrides)
  end
end

end

