class Packages::Create < Less::Interaction
  include Packages::Params
  
  expects :context
  
  def run    
    create
  end
  
  private
  
  def package
    @package ||= context.hotel.packages.build package_params
  end
  
  def create
    clean_add_on_ids
    if add_on_ids.blank?
      package.valid?
      package.errors.add :add_on_ids, "must choose and Add On"
      return package
    end
    save
    package
  end
  
  def save
    begin
      Package.transaction do
        package.save!
        add_on_ids.each do |add_on_id|
          package.bundles.create! :add_on_id => add_on_id
        end
      end
    rescue ActiveRecord::RecordInvalid
      false
    end
    true
  end
  
end