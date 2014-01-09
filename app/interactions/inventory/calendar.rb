class Inventory::Calendar < Less::Interaction
  
  expects :context
  
  def run
    Inventory::Month.new date, context.hotel
  end
  
  
  private
  def date
    return @date if @date
    @date = Date.new context.params[:id].to_i if context.params[:id]
    @date ||= Date.new(context.params[:year].to_i, context.params[:month].to_i) if context.params[:year] && context.params[:month]
    @date ||= Date.current
  end
  
  
end