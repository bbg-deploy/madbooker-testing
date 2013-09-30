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
    minitest:models
    minitest:controllers
    minitest:decorators
  )
    # minitest:integration 
    # minitest:mailers 
    # minitest:lib 
    # test:jasmine
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
                   ..oo$00ooo..                    ..ooo00$oo..
                .o$$$$$$$$$'                          '$$$$$$$$$o.
             .o$$$$$$$$$"             .   .              "$$$$$$$$$o.
           .o$$$$$$$$$$~             /$   $\\              ~$$$$$$$$$$o.
         .{$$$$$$$$$$$.              $\\___/$               .$$$$$$$$$$$}.
        o$$$$$$$$$$$$8              .$$$$$$$.               8$$$$$$$$$$$$o
       $$$$$$$$$$$$$$$              $$$$$$$$$               $$$$$$$$$$$$$$$
      o$$$$$$$$$$$$$$$.             o$$$$$$$o              .$$$$$$$$$$$$$$$o
      $$$$$$$$$$$$$$$$$.           o{$$$$$$$}o            .$$$$$$$$$$$$$$$$$
     ^$$$$$$$$$$$$$$$$$$.         J$$$$$$$$$$$L          .$$$$$$$$$$$$$$$$$$^
     !$$$$$$$$$$$$$$$$$$$$oo..oo$$$$$$$$$$$$$$$$$oo..oo$$$$$$$$$$$$$$$$$$$$$!
     {$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$}
     6$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$?
     '$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
      o$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$o
       $$$$$$$$$$$$$$;'~`^Y$$$7^''o$$$$$$$$$$$o''^Y$$$7^`~';$$$$$$$$$$$$$$$
       '$$$$$$$$$$$'       `$'    `'$$$$$$$$$'     `$'       '$$$$$$$$$$$$'
        !$$$$$$$$$7         !       '$$$$$$$'       !         V$$$$$$$$$!
         ^o$$$$$$!                   '$$$$$'                   !$$$$$$o^
           ^$$$$$"                    $$$$$                    "$$$$$^
             'o$$$`                   ^$$$'                   '$$$o'
               ~$$$.                   $$$.                  .$$$~
                 '$;.                  `$'                  .;$'
                    '.                  !                  .`
    }


  end
end

