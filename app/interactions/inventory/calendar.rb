class Inventory::Calendar < Less::Interaction
  
  expects :context
  
  def run
    Inventory::Month.new date, context.hotel
  end
  
  
  private
  def date
    return @date if @date
    @date = Date.current unless context.params[:year] && context.params[:month]
    @date ||= Date.new context.params[:year].to_i, context.params[:month].to_i
  end
  
  
end