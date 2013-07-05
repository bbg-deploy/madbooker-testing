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
  
  def self.short_list
    [usd, cad, eur, gbp]
  end
  
  def self.all_but_short_list
    all_currencies - short_list
  end

  
  def self.usd
    @usd ||= find_by_code('USD') || raise("USD currency not found.")
  end
  
  
  def self.cad
    @cad ||= find_by_code('CAD') || raise("CAD currency not found.")
  end
  def self.gbp
    @gbp ||= find_by_code('GBP') || raise("GBP currency not found.")
  end
  def self.eur
    @eur ||= find_by_code('EUR') || raise("EUR currency not found.")
  end

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
  
  def self.all_currencies
    @all_currencies ||= find(:all, :order => 'code ASC') # Cache these since they almost never change.
  end
  
  
end
