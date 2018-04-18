# config valid for current version and patch releases of Capistrano
lock "~> 3.10.1"

set :user, 'deploy'
set :application, 'contactbook'
set :repo_url, 'git@github.com:Phani1661988/contactbook.git' # Edit this to match your repository
set :branch, :master
set :deploy_to, '/home/deploy/contactbook'
set :pty, true
# set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa) }
set :ssh_options, {
 forward_agent: true,
 auth_methods: ["publickey"],
 keys: %w(/home/phani/Downloads/phanikey2.pem)
}



namespace :deploy do

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end