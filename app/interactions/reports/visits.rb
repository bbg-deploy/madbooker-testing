class Reports::Visits < Less::Interaction

  expects :data

  def run
    init_rows( @data[:rows]).to_json
    #@data
  end
  
  private
    
  
  def init_rows rows
    arr = []
    rows.each do |row|
      o = uninited_row(date: date_for_str(row[col_index_for_date]))
      fill_from_rows o, row
      arr << o
    end
    arr
  end
  
  def uninited_row( date: nil)
    OpenStruct.new date: date
  end
  
  def date_for_str str
    Date.parse "#{str[0,4]}-#{str[4,2]}-#{str[6,2]}"
  end
  
  def fill_from_rows o, row
    @data[:columnHeaders].each_with_index do |col, index|
      next if col[:name] == "ga:date"
      o.send "#{col[:name].gsub("ga:", "")}=", row[index]
    end
  end
  
  def col_index_for_date
    return @col_index_for_date if @col_index_for_date
    i = nil
    @data[:columnHeaders].each_with_index do |col, index|
      i = index and break if col[:name] == "ga:date"
    end
    @col_index_for_date = i
  end
  
end