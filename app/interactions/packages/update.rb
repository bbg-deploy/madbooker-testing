class Packages::Update < Less::Interaction
  include Packages::Params
  
  expects :context
  
  def run    
    update
  end
  
  private
  
  def package
    @package ||= context.hotel.packages.find context.params[:id]
  end
  
  def update
    clean_add_on_ids
    context.params[:package].each do |para, val|
      package.send "#{para}=", val
    end
    
    if add_on_ids.blank?
      package.valid?
      package.errors.add :add_on_ids, "must choose and Add On"
      return package
    end
    package.add_on_ids = add_on_ids
    save
    package
  end
  
  def save
    package.save
  end
  
end