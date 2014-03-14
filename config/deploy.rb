require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, '89.108.70.205'
set :deploy_to, '/var/www/sovia.ru'
set :repository, 'git@github.com:ozgg/Sovia.git'
set :branch, 'master'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, %w(config/database.yml config/initializers/secret_token.rb log tmp public/uploads)

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  invoke :'rbenv:load'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[mkdir -p "#{deploy_to}/shared/config/initializers"]
  queue! %[mkdir -p "#{deploy_to}/shared/public"]
  queue! %[mkdir -p "#{deploy_to}/shared/public/uploads"]
  queue! %[mkdir -p "#{deploy_to}/shared/tmp"]
  queue! %[mkdir -p "#{deploy_to}/shared/tmp/pids"]

  queue! %[chmod -R g+rx,u+rwx "#{deploy_to}/shared"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue! %[touch "#{deploy_to}/shared/config/initializers/secret_token.rb"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml' and 'initializers/secret_token.rb'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      queue! "bundle exec pumactl -S #{deploy_to}/shared/tmp/puma.state restart"
    end
  end
end
