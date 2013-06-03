

class Numeric
  def c(unit = '')
    number_to_currency(self, :unit=>unit)
  end
  def delim
    number_with_delimiter(self)
  end
  
  
  def to_clock
    m, s = self.divmod(60)
    h, mi = m.divmod(60)
    hours = h.to_s.rjust(2, '0')
    minutes = mi.to_s.rjust(2, '0')
    seconds = s.to_s.rjust(2, '0')
    "#{hours}:#{minutes}:#{seconds}"
  end
end
