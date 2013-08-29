class Hotel::Gaa < Less::Interaction
  
  expects :context
  expects :less_ga
  
  def run    
    fill_in_as_much_data_as_possible
    self
  end
  
  def go_to_report?
    return true if context.hotel.ga_profile_id && context.hotel.gauth_access_token && context.hotel.ga_account_id
    # if context.params[:profile_id]
    #   set_profile_id
    #   return true
    # end
    # if context.params[:account_id]
    #   set_account_id
    #   return true if @profiles.size == 1
    # end
    false
  end
  
  def need_to_pick_account?
    context.hotel.ga_account_id.blank? && !accounts.blank?
  end
  
  def need_to_pick_profile?
    return false if need_to_pick_account?
    context.hotel.ga_profile_id.blank? && !profiles.blank?
  end
  
  def accounts
    return @accounts if @accounts
    @accounts = less_ga.data.accounts
    return @accounts = [] unless @accounts.is_a?( Hash) && @accounts.has_key?(:items) && @accounts[:items].size > 0
    if @accounts[:items].size == 1
      set_account_id @accounts[:items][0][:id]
      get_profiles @accounts[:items][0][:id]
    end
    @accounts
  end
  
  def profiles
    return @profiles if @profiles
    account_id = context.params[:account_id] || context.hotel.ga_account_id
    return @profiles = [] unless account_id
    @profiles = get_profiles account_id
  end
  
  private
  def fill_in_as_much_data_as_possible
    accounts if context.hotel.ga_account_id.blank?
    profiles if context.hotel.ga_profile_id.blank?
  end
  
  def set_profile_id profile_id = context.params[:profile_id]
    context.hotel.update_attribute :ga_profile_id, profile_id
  end
  
  def set_account_id account_id = context.params[:account_id]
    context.hotel.update_attribute :ga_account_id, account_id
    get_profiles
  end
  
  def get_profiles account_id = context.params[:account_id]
    @profiles = less_ga.data.profiles account_id
    if @profiles[:items].size == 1
      set_profile_id @profiles[:items][0][:id]
    end
    @profiles
  end
  
end
