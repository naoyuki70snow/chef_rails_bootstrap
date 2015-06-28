rails_root = File.expand_path('../../', __FILE__)

worker_processes 2 # this should be >= nr_cpus
working_directory rails_root

listen "#{rails_root}/tmp/sockets/unicorn.sock"
pid "#{rails_root}/shared/pids/unicorn.pid"

stderr_path "#{rails_root}/shared/log/unicorn_stderr.log"
stdout_path "#{rails_root}/shared/log/unicorn_stdout.log"
