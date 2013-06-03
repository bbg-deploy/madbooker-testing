require 'active_support/core_ext/string'

class Lessapp < Thor
 include Thor::Actions

  desc "clone <name> [<domain>]", "clones a project to new name <name>"
  def clone(name, domain = nil)
    domain ||= "#{name}.com"
    run "git pull"
    run "bundle install"
    source_paths << "."
    inside('..') do
      run("rails new #{name} --skip-git --skip-gemfile")
    end

    directory "app", "../#{name}/app", :force => true
    directory "db", "../#{name}/db", :force => true
    directory "test", "../#{name}/test", :force => true
    directory "lib", "../#{name}/lib", :force => true
    directory "public", "../#{name}/public", :force => true
    directory "vendor", "../#{name}/vendor", :force => true

    copy_file ".gitignore", "../#{name}/.gitignore"
    copy_file "Gemfile", "../#{name}/Gemfile"
    copy_file "Gemfile.lock", "../#{name}/Gemfile.lock"
    copy_file "config/routes.rb", "../#{name}/config/routes.rb", :force => true
    gsub_file "../#{name}/config/routes.rb", /Lessapp/, name.classify
    copy_file "config/database.yml", "../#{name}/config/database.yml", :force => true
    copy_file "config/database.yml", "../#{name}/config/database.yml.tmp", :force => true
    gsub_file "../#{name}/config/database.yml", /lessapp/, name

    inside("../#{name}") do
      remove_file "public/index.html"
      remove_file "app/views/layouts/application.html.erb"
      run "rails g devise:install"
      run "rails g simple_form:install"
      run "rails g jquery:install --force"
      run "rake db:create:all"
      run "rake mig"
      run "rails g lessapp #{domain}"
      run "git init"
      run "git add ."
      run "git commit -a -m 'initial import'"
      run "ssh batman.lesseverything.com \"cd /git;mkdir #{name}.git;cd #{name}.git;git --bare init; chmod -R o-rw .\""
      run "git remote add origin ssh://git.lesseverything.com/git/#{name}.git"
      run "git push origin master"
    end
  end

end