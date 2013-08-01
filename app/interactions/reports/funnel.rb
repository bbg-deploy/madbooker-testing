class Reports::Funnel < Less::Interaction
  
  
  def run
    self
  end
  
  def data
    @data ||= fill_data.to_json
  end
  
  
  
  
  private 
  def get_data
    @get_data ||= context.hotel.stats.pages.group(:url, "month(created_at)").count
  end
  
  def fill_data
    a = []
    init_months do |m| 
      struct = uninited_row month: m
      a << struct
    end
    get_data.each do |k,v|
      url = k[0]
      count = v
      month = k[1]
      struct = a.select{|x| x.date.month == month}.first
      struct.urls << uninited_data(fix_url(url), count)
    end
    normalize_data( ensure_each_has_same_urls a)
  end
  
  def fix_url url
    url.log
    "http://xx.madbooker.dev/book"
    "http://xx.madbooker.dev/book?a=1"
    "http://xx.madbooker.dev/book?error=499"
    "http://xx.madbooker.dev/book/checkout"
    "http://xx.madbooker.dev/book/select_dates"
    "http://xx.madbooker.dev/book/select_room"
    "http://xx.madbooker.dev/bookings/0d7b0b80703b42debbdca0a24edc56a9"
    "http://xx.madbooker.dev/bookings/a3966bd7ccfe4980adb33d4a9f0397ef"

    case true
    when url.blank?
      "none"
    when "bookings" =~ /#{url}/
      "Booked"
    when url.ends_with?( "select_room")
      "Step2"
    else
      "ASdf"
    end
  end
    
  def uninited_row( month: nil)
    OpenStruct.new date: month, urls: []
  end
  
  def uninited_data url = "", count = 0
    OpenStruct.new url: url, count: count
  end
  
  def init_months
    (Date.current.beginning_of_year.month..Date.current.month).to_a.each do |month|
      yield date_for_month(month)
    end
  end
  
  def date_for_month month
    Date.current.change( month: month, day: 1)
  end
  
  def ensure_each_has_same_urls arr
    urls = arr.map(&:urls).flatten.map{|a| a.url}.flatten.uniq
    arr.each do |struct|
      urls.each do |url|
        next if url.in? struct.urls.map(&:url)
        struct.urls << uninited_data(url)#, (rand*100).to_i)
      end
    end
    arr
  end
  
  def normalize_data arr
    out = []
    arr.each do |month|
      struct = uninited_row month: month.date
      struct.urls = normalize_urls month.urls
      out << struct      
    end
    out
  end
  
  # removes simliar urls while retaining their counts
  def normalize_urls urls_and_counts
    out = []
    urls_and_counts.each do |url_and_count|
      url = fix_url url_and_count.url
      new_url_and_count = out.select{|x| x.url == url}.first
      if new_url_and_count.nil?
        new_url_and_count = uninited_data url
        out << new_url_and_count
      end
      new_url_and_count.count += url_and_count.count
    end
    out
  end
  
end