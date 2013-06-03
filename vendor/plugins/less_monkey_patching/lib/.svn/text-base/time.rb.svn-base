
class Time
  def days_ago time = ::Time.now
    ((time - self) / 60 / 60 /24).round
  end
  
  
  #used for Timezone insensitive comparisons
  def === t
    self.year == t.year && 
      self.month == t.month &&
      self.day == t.day &&
      self.hour == t.hour &&
      self.min == t.min &&
      self.sec == t.sec
  end
  
  
  def last_week
    self - 7.days
  end
  
  def next_week
    self + 7.days
  end
  


  def tz person
    TZInfo::Timezone.get( person.time_zone).utc_to_local(utc)
  end
  def self.get_utc_from_string tz, str
    return str if str.blank?
    t = Chronic.parse str
    t ||= Time.parse str
    tz.local_to_utc(t) 
  end
  
end