class Reports::X < Less::Interaction

  expects :data

  def run
    init_rows( @data[:rows]).to_json
    
  end
  
  private
  
  
  
  def init_rows rows
    arr = []
    rows.each do |row|
      arr << uninited_row(date: date_for_str(row[0]), val: row[1].to_i)
    end
    arr
  end
  
  def uninited_row( date: nil, val: 0.0)
    OpenStruct.new date: date, val: val
  end
  
  def date_for_str str
    Date.parse "#{str[0,4]}-#{str[4,2]}-#{str[6,2]}"
  end
  
end