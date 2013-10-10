class Exceptions
  
  def self.record ex, data = nil
    Honeybadger.context({data: data})
    Honeybadger.notify ex
    ex
  end
  
  
end