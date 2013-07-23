class Hotel::RevenueByRoomType < Less::Interaction
  
  
  def run
    fill_them_up
    output
  end
  
  private
  
  def fill_them_up
    fill_for_week
    fill_for_month
    fill_for_average
  end
  
  def fill_for_week
    grouped = get_data Time.week, :sum
    fill_from_group grouped, :week
  end
  
  def fill_for_month
    grouped = get_data Time.month, :sum
    fill_from_group grouped, :month
  end
  
  def fill_for_average
    grouped =  get_data Time.month, :average
    fill_from_group grouped, :average
  end
  
  def get_data range, method
    #{[1, "RoomType"]=>180.0, [8, "Package"]=>75.0}
    context.hotel.sales.range(range).paid.group([:bookable_id, :bookable_type]).send method, :price
  end
  
  def fill_from_group group, method
    output.each do |out|
      group.each do |k, v|
        next unless out.id == k[0] && out.type == k[1]
        out.send "#{method}=", v
      end
    end
  end
  
  
  def output
    return @output if @output
    @output = []
    context.hotel.room_types.each do |room_type|
      @output.push build_output_item(room_type)
    end
    context.hotel.packages.active.each do |room_type|
      @output.push build_output_item(room_type)
    end
    @output
  end
  
  def build_output_item bookable
    OpenStruct.new name: bookable.decorate.name, id: bookable.id, type: bookable.class.to_s, week: 0, month: 0, average: 0
  end
  
end