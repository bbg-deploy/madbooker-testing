class PackageDecorator < ApplicationDecorator
  delegate_all
  
  
  delegate :image, to: :room_type

  def activate_link
    str = active? ? "Inactivate" : "Activate"
    link_to str, [current_hotel, self], method: :delete, remote: true
  end
  
  def room_name
    "#{room_type.name} with #{add_ons.map( &:name).to_sentence}"
  end

  def description
    d = [room_type.description] + add_ons.map(&:description)
    d.join " "
  end
  
  def with_inventory inventory
    @inventory = inventory
    self
  end
  
  def rate
    @inventory.rate + model.additional_price
  end
  
  def discounted_rate
    if @inventory.discounted_rate.nil?
      nil
    else
      @inventory.discounted_rate + model.additional_price
    end
  end
  
  def name
    room_name
  end
  
  private
  

end
