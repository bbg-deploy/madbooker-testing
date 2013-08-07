class Exceptions
=begin
  TODO record this in a proper way once some exception handling service is chosen
=end  
  def self.record ex, data = nil
    p ex.log
    p data if data
    ex
  end
  
  
end