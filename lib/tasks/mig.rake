def system_puts(cmd)
  puts cmd
  system cmd
end

desc "Migrate, clone structure to test, and annotate"
task :mig do
  system_puts 'rake db:migrate RAILS_ENV="development"'
  system_puts 'rake db:test:clone_structure'
  system_puts 'annotate -p before'
end
