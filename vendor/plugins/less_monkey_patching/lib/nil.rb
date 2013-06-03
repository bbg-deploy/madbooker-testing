class NilClass
  
  def each
    nil
  end
  
  def dup
    nil
  end
  
  
  def [] key
    nil
  end
  
  
  def if_blank value = ''
    value
  end
  
  
  def if_not_blank before = '', after = ''
    nil
  end
  
  
end