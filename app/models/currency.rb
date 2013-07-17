# == Schema Information
#
# Table name: currencies
#
#  id          :integer          not null, primary key
#  code        :string(255)
#  html_symbol :string(255)
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Currency < ActiveRecord::Base
  
  scope :short_list, ->{where "code in ('USD', 'CAD', 'GBP', 'EUR')"}
  scope :all_but_short_list, ->{where "code not in ('USD', 'CAD', 'GBP', 'EUR')"}
  scope :all_currencies, ->{order "code ASC"}
  
  scope :usd, ->{where "code = 'USD'"}
  scope :cad, ->{where "code = 'CAD'"}
  scope :gbp, ->{where "code = 'GBP'"}
  scope :eur, ->{where "code = 'EUR'"}
  
  

  def self.options_for_select selected_id = -1
    (short_list + all_but_short_list).map {|c| c.to_option}#2(c.id == selected_id)}
  end
  
  def html_symbol
    read_attribute(:html_symbol) && read_attribute(:html_symbol).html_safe || ''
  end

  def label
    "#{code}" + ( html_symbol.blank? || html_symbol.include?("&") ? '' : " ( #{html_symbol} )" )
  end

  def to_option
    [ label, id]
  end
  
  
end
