class Inventory::Calendar < Less::Interaction
  
  expects :context
  
  def run
    Inventory::Month.new date, context.hotel
  end
  
  
  private
  def date
    return @date if @date
    @date = Date.current unless context.params[:id]
    @date ||= Date.new context.params[:id].to_i
  end
  
  
end