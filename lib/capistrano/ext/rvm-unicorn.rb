require 'capistrano/ext/rvm'

Capistrano::Configuration.instance.load do

  namespace :deploy do
    desc "Start unicorn server"
    task :start, :roles => :app, :except => { :no_release => true } do
      run "cd #{current_path} && rvm '#{rvm_ruby_string}' && unicorn_rails -c #{unicorn_config} -E #{rails_env} -D"
    end

    desc "Stop unicorn server"
    task :stop, :roles => :app, :except => { :no_release => true } do
      run "kill -9 `cat #{unicorn_pid}`" unless ENV['NOKILL']
    end

    desc "Stop unicorn server gracefuly"
    task :graceful_stop, :roles => :app, :except => { :no_release => true } do
      run "kill -s QUIT `cat #{unicorn_pid}`"
    end

    desc "Reload unicorn server via sending USR2 signal"
    task :reload, :roles => :app, :except => { :no_release => true } do
      run "kill -s USR2 `cat #{unicorn_pid}`"
    end

    desc "Restart unicorn server"
    task :restart, :roles => :app, :except => { :no_release => true } do
      stop
      start
    end
  end

end
