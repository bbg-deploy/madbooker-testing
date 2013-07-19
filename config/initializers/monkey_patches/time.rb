class Time
  
  def self.week
    zone.now.all_week
  end
  
  def self.month
    zone.now.all_month
  end
end