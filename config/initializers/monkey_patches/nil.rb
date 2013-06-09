class NilClass
    
  def log color = :red
    Rails.logger.debug "nil".send(color)
    nil
  end
  
end