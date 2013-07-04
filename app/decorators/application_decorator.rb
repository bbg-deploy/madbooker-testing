class Draper::CollectionDecorator
  #will_paginate
  delegate :current_page, :total_entries, :total_pages, :per_page, :offset
  #ar
  delegate :includes
end

class ApplicationDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers
  
end