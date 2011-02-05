set :rvm_ruby_string, '1.8.7'        # Or whatever env you want it to run in.
# set to the name of git remote you intend to deploy to
set :remote, "dev"
# specify the deployment branch
set :branch, "master"
# sudo will only be used to create the deployment directory
set :use_sudo, false
# the remote host is read automatically from your git remote specification
server remote_host, :app, :web, :db, :primary => true