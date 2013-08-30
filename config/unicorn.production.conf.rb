APP_HOME = '/home/restest/ResTest'
worker_processes 2

working_directory "#{APP_HOME}/current" # available in 0.94.0+

listen '127.0.0.1:3003', :tcp_nopush => true
timeout 60

pid "#{APP_HOME}/shared/pids/unicorn.pid"

stderr_path "#{APP_HOME}/shared/log/unicorn.stderr.log"
stdout_path "#{APP_HOME}/shared/log/unicorn.stdout.log"

preload_app true

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect!

  # # This allows a new master process to incrementally
  # phase out the old master process with SIGTTOU to avoid a
  # thundering herd (especially in the "preload_app false" case)
  # when doing a transparent upgrade.  The last worker spawned
  # will then kill off the old master process with a SIGQUIT.
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end

  # *optionally* throttle the master from forking too quickly by sleeping
  sleep 1
end

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection
end
