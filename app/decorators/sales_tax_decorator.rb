class SalesTaxDecorator < ApplicationDecorator
  delegate_all
  

  def quantity nights
    if per_stay?
      1
    else
      nights
    end
  end
  
  def price rate, nights
    if per_stay?
      price_for_stay rate
    else
      price_for_nights rate, nights
    end
  end
  
  def amount_string
    if calculated_how == SalesTax::FIXED_AMOUNT
      h.format amount
    else
      format_percentage amount
    end
  end
  
  
  protected
  
  def price_for_stay rate
    if fixed_amount?
      amount
    else
      calc_percent rate
    end
  end
  
  def price_for_nights rate, nights
    if fixed_amount?
      (amount * nights).round 2
    else
      calc_percent(rate) * nights
    end      
  end
  
  def calc_percent rate
    (rate * amount * 0.01).round 2
  end

end
