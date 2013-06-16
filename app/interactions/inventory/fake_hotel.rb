
#this class used to emulate a hotel so we can still use form_for, fields_for
class Inventory::FakeHotel
  attr_accessor :inventories, :id
  
  def initialize id
    self.id = id
  end

  def self.model_name
    ActiveModel::Name.new Hotel
  end

  def to_key
    ["hotel"]
  end
  
  def inventories
    @inventories || []
  end
  def inventories= i
    @inventories = i
  end
  def inventories_attributes= hash
    #placeholder to make fields_for work
  end
end