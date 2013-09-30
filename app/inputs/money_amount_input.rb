class MoneyAmountInput < SimpleForm::Inputs::StringInput

  def input_html_options
    # see: https://github.com/drapergem/draper/issues/77#issuecomment-3521709
    # Decorator's methods are not used by form builder (draper's author opinion)
    # so with this, we're changing that behaviour for this input type
    if @input_html_options[:value].blank?
      @input_html_options[:value] = ((object.respond_to?(:model) && object.try(:model)) || object).send attribute_name
    end
    @input_html_options[:value] = @input_html_options[:value].to_s
    @input_html_options[:type] = "text"
    @input_html_options
  end
  
  def input
    i = input_html_options
    i[:value] = two_decmial_spaces i[:value]
    @builder.text_field attribute_name, i
  end
  
  def two_decmial_spaces str
    return str if str.blank?
    return "#{str}.00" unless str["."]
    return str if str[-3] == "."
    return "#{str}0" if str[-2] == "."
    return "#{str}00" if str[-1] == "."
    str
  end

end
