require 'pathname'

environment 'production'

app_root = Pathname.new('../../').expand_path(__FILE__).to_s

logs_dir = File.realpath("#{app_root}/log")
tmp_dir  = File.realpath("#{app_root}/tmp")
pids_dir = File.realpath("#{tmp_dir}/pids")

pidfile "#{pids_dir}/puma.pid"
state_path "#{tmp_dir}/puma.state"

bind "unix://#{tmp_dir}/puma.sock"

stdout_redirect "#{logs_dir}/stdout.log", "#{logs_dir}/stderr.log", true
