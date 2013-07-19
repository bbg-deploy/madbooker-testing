def system_puts(cmd)
  puts cmd
  system cmd
end

desc "Gen ERD"
task :erd do
  system_puts 'erd --exclude="Hotel,User,Membership,Currency" --open --attributes="foreign_keys,primary_keys,content,inheritance"'
end
