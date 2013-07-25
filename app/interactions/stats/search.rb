class Stats::Search < Less::Interaction
  
  expects :available_rooms
  
  def run
    save
  end
  
  
  private
  def save
    Stat.search context: context, available_rooms: sort_out_rooms, dates: range
  end
  
  def sort_out_rooms
    available_rooms.map &:room_type_id
  end
  
  def range
    s = Chronic.parse context.params[:booking][:arrive]
    e = Chronic.parse context.params[:booking][:depart]
    s..e
  end
  
  
  
end