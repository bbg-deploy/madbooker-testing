

class Numeric
  include ActionView::Helpers::NumberHelper
  def to_currency(unit, html_entities = true, options = {})
    unit = case
           when unit.respond_to?(:html_symbol) && unit.html_symbol? && html_entities
             "#{unit.html_symbol}"
           when unit.respond_to?(:code)
             "#{unit.code} "
           when unit.blank?
             "" # "&curren;" # Generic currency symbol
           else
             unit
           end
     number = self.round(2) rescue self
     number_to_currency(number, options.merge(:unit => unit.html_safe, :negative_format => "%u-%n")).html_safe
  end

  def c(unit = '')
    to_currency(unit)
  end
  
end
