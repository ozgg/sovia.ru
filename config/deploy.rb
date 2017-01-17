require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'

set :domain, '89.108.104.88'
set :deploy_to, '/var/www/sovia.ru'
set :repository, 'git@github.com:ozgg/Sovia.git'
set :branch, 'master'

# Optional settings:
set :user, 'developer'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_dirs, fetch(:shared_dirs, []).push('tmp', 'log', 'public/uploads')
set :shared_files, fetch(:shared_files, []).push('.env', 'public/sitemap.dreambook.xml', 'public/sitemap.dreams.xml', 'public/sitemap.posts.xml', 'public/sitemap.questions.xml')

# This task is the environment that is loaded all remote run commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  invoke :'rbenv:load'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  # command %{rbenv install 2.3.0}
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
      end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run :local { say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/docs
