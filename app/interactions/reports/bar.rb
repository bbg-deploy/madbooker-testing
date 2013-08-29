class Reports::Bar < Less::Interaction

  expects :data
  expects :dimension

  def run
    #init_rows( @data[:rows]).to_json
    #@data
    self
  end
    
  def headers
    @headers ||= sorted_data.map &:city
  end
  
  def series
    @series ||= [{
      name: "Visits",
      data: sorted_data.map( &:visits)
    }]
  end
  
  private
  
  def sorted_data
    return @sorted_data if @sorted_data
    arr = []
    @data[:rows].each do |row|
      arr << OpenStruct.new(city: row[cities_index], visits: row[visits_index].to_i)
    end
    @sorted_data = only_top_results arr
  end
  
  def cities_index
    return @cities_index if @cities_index
    @cities_index = col_index dimension
  end
  
  def visits_index
    return @visits_index if @visits_index
    @visits_index = col_index "ga:visits"
  end
  
  def col_index name
    @data[:columnHeaders].each_with_index do |col, index|
      return index if col[:name] == name
    end
  end
  
  def init_rows rows
    arr = []
    rows.each do |row|
      o = OpenStruct.new
      fill_from_rows o, row
      arr << o
    end
    only_top_results arr
  end
    
  def fill_from_rows o, row
    @data[:columnHeaders].each_with_index do |col, index|
      if col[:name] == "ga:visits"
        val = row[index].to_i
      else
        val = row[index]
      end
      o.send "#{col[:name].gsub("ga:", "")}=", val
    end
  end
  
  def only_top_results arr
    arr.sort {|a,b| b.visits <=> a.visits}[0,20]
  end
  
end