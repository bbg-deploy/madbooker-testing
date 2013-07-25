class NilClass
    
  def log color = :red
    Rails.logger.debug "nil".send(color)
    nil
  end
  
  def to_d
    0.to_d
  end
  
end