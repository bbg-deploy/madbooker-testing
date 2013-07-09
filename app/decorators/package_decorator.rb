class PackageDecorator < ApplicationDecorator
  delegate_all

  def activate_link
    str = active? ? "Inactivate" : "Activate"
    link_to str, [current_hotel, self], method: :delete, remote: true
  end
  
  def room_name
    room_type.name
  end

  def description
    "fill me in"
  end

end
