namespace :nginx do
  desc "Install latest stable release of nginx"
  task :install, roles: :web do
    run "#{sudo} add-apt-repository ppa:nginx/stable --yes"
    run "#{sudo} apt-get -y install nginx"
  end

  desc "Setup nginx configuration for this application"
  task :setup, roles: :web do
    template "nginx_unicorn_#{stage}.erb", "/tmp/nginx_conf"
    run "#{sudo} mv /tmp/nginx_conf /etc/nginx/sites-enabled/#{application}_#{stage}"
    restart
  end
  after "deploy:setup", "nginx:setup"

  %w[start stop restart].each do |command|
    desc "#{command} nginx"
    task command, roles: :web do
      run "#{sudo} service nginx #{command}"
    end
  end
end
