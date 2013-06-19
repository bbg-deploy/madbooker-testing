namespace "test" do
  desc "Test Jasmine"
  task :jasmine => :environment do |t|
    system('jasmine-headless-webkit')
  end
end

# overriding Rails test task
Rake::Task["test"].try(:clear)
task :test => [] do 
  test_tasks = %w(
    minitest:interactions  
    minitest:interactions2  
    minitest:mailers 
    minitest:lib 
    minitest:unit
    minitest:functional
    minitest:integration 
    test:jasmine
  )
  errors = test_tasks.collect do |task|
    begin
      puts "\n***** #{task}\n"
      Rake::Task[task].invoke
      nil
    rescue => e
      puts "ERROR! #{e.message}"
      { :task => task, :exception => e }
    end
  end.compact

  if errors.any?
    puts errors.map { |e| "Errors running #{e[:task]}!" }.join("\n")
    abort
  else
    puts %{
           o888P     Y8o8Y     Y888o.
         d88888      88888      88888b
       ,8888888b_  _d88888b_  _d8888888,
       888888888888888888888888888888888
       888888888888888888888888888888888
        Y8888P"Y888P"Y888P-Y888P"Y88888'
         Y888   '8'   Y8P   '8'   888Y
          '8o          V          o8'
    }


  end
end

