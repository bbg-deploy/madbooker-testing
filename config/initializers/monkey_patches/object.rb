class Object

  def log color = :red
    Rails.logger.debug inspect.send(color)
    self
  end

  def to_bool
    return false unless self
    return false if self.to_s =~ /0|no|false/
    true
  end

  def not_in?(*args)
    !in?( *args)
  end 

end

