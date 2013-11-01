class Exceptions
  
  def self.record exception, data = {}
    
    exception ||= $!
    if exception.is_a?(String)
      exception = RuntimeError.new(exception)
    end
    
    Honeybadger.context({data: data})
    Honeybadger.notify exception
    if Rails.env.development?
      exception.log
      data.log
    end
    exception
  end
  
  
end