worker_processes 4

working_directory "/srv/apps/madbooker/current"

pid "/srv/apps/madbooker/current/tmp/pids/unicorn.pid"
listen "/srv/apps/madbooker/current/tmp/unicorn.sock", :backlog => 64
timeout 30

stderr_path "/srv/apps/madbooker/current/log/unicorn.stderr.log"
stdout_path "/srv/apps/madbooker/current/log/unicorn.stdout.log"

GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
  old_pid = "#{server.pid}.oldbin"
  # kill off the old master
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # the following is *required* for Rails + "preload_app true",
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
