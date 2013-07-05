class AddOnDecorator < ApplicationDecorator
  delegate_all

  def activate_link
    str = active? ? "Inactivate" : "Activate"
    link_to str, [current_hotel, self], method: :delete, remote: true
  end

end
