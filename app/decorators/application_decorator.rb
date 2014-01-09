class Draper::CollectionDecorator
  #will_paginate
  delegate :current_page, :total_entries, :total_pages, :per_page, :offset
  #ar
  delegate :includes
end

class ApplicationDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers
  
  
  def sub_breaks text
    text.gsub("\n", "<br/>").html_safe
  end

#blah5
  
end
