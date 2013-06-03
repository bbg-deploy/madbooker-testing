require File.dirname(__FILE__) + '/helper'
require File.dirname(__FILE__) + '/../lib/numeric'
#require File.join(File.dirname(__FILE__), '../../../../config/environment')


class Numeric
  def hour
    self * 3600
  end
  def minute
    self * 60 
  end
end


class NumericTest < LessTests
  
  def test_to_clock
    assert_equal "00:01:00", 60.to_clock
    assert_equal "00:00:04", 4.to_clock
    assert_equal "00:02:40", 160.to_clock
    assert_equal "01:00:00", 3600.to_clock
    assert_equal "01:00:01", 3601.to_clock
    assert_equal "3428120:52:03", 12341235123.to_clock
  end
end
