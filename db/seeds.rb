

def execute_sql_file(filename)
  sql = File.open("#{Rails.root}/db/sql/#{filename}").read
  sql.split(";\n").each do |sql_statement|
    next if sql_statement.blank?
    ActiveRecord::Base.connection.execute(sql_statement)
  end
end



if Currency.count == 0
  execute_sql_file('currencies.sql')
end
