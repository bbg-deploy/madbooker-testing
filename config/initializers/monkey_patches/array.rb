class Array
  
  
  
  def average
    return nil if any? {|i| i.nil?}
    reduce(:+) / size
  end
  
  
end