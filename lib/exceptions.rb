class Exceptions
  
  def self.record exception, data = nil
    
    exception ||= $!
    if exception.is_a?(String)
      exception = RuntimeError.new(exception)
    end
    
    Honeybadger.context({data: data})
    Honeybadger.notify exception
    exception
  end
  
  
end