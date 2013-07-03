class Draper::CollectionDecorator
  delegate :current_page, :total_entries, :total_pages, :per_page, :offset
end

class ApplicationDecorator < Draper::Decorator
  include Draper::LazyHelpers
  
end