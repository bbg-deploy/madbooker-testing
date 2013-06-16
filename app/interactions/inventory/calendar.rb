class Inventory::Calendar < Less::Interaction
  
  expects :context
  
  class Month
    attr_accessor :date, :hotel
    
    def previous_month
      date.advance months: -1
    end
    
    def next_month
      date.advance months: 1
    end
    
    def inventory_on date
      i = @inventories.select {|i| i.date == date}
      return [] if i.blank?
      i
    end
    
    def inventories
      @inventories
    end
    
    private
    def run
      @inventories = hotel.inventories.for_month( date).all
      self
    end
  end
  
  
  def run
    @month = Month.new
    @month.date = date
    @month.hotel = context.hotel
    @month.send :run
    @month
  end
  
  
  private
  def date
    return @date if @date
    @date = Date.today unless context.params[:year] && context.params[:month]
    @date ||= Date.new context.params[:year].to_i, context.params[:month].to_i
  end
  
  
end