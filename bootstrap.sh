#!/usr/bin/env bash

echo '******************************************************'
echo "Vagrant image provisioning started at "
date
date > /etc/vagrant_provisioned_at
echo '******************************************************'
# 1. Apply updates and install essential dependencies
echo ''
echo '******************************************************'
echo '****** STEP 1 of 10 ***** Applying Ubuntu Updates and installing dependencies'
echo '******************************************************'
echo ''
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install git-core build-essential zlib1g-dev nodejs libpq-dev

# 2. Configure GIT
echo ''
echo '******************************************************'
echo '****** STEP 2 of 10 ***** Configuring GIT'
echo '******************************************************'
echo ''

cd /vagrant
git config --global core.autocrlf input
git config --global color.ui true
git config --global push.default simple
git config --global pull.rebase true
git config --global alias.changed "show --pretty=\"format:\" --name-only"
git config --global alias.nicelog "log --pretty=format:'%Cgreen%cd [%h] %Cblue<%an> %Cred%s' --date-order"
git config --global alias.s "status -s"
git config --global alias.lg "log --oneline --decorate --all --graph"
git config --global alias.g "grep --break --heading --line-number"
git remote add upstream https://github.com/coopdevs/timeoverflow.git

# 3.Install RVM
echo ''
echo '******************************************************'
echo '****** STEP 3 of 10 ***** Installing RVM'
echo '******************************************************'
echo ''

gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
\curl -L https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh

# 4.Install ruby 2.2.0 and bundler
echo ''
echo '******************************************************'
echo '****** STEP 4 of 10 ***** Installing ruby 2.2.0'
echo '******************************************************'
echo ''

rvm install 2.2.0
rvm use 2.2.0
rvm --default 2.2.0

# 5.Install bundler and apply gems from Gemfile.lock
echo ''
echo '******************************************************'
echo '****** STEP 5 of 10 ***** Installing Bundler and TimeOverflow gems'
echo '******************************************************'
gem install bundler
bundle install

# 6.Install and setup PostgreSQL 9.3
echo ''
echo '******************************************************'
echo '****** STEP 6 of 10 ***** Installing and configuring PostgreSQL for development'
echo '******************************************************'
echo ''
sudo apt-get -y install postgresql postgresql-contrib
pg_hba=`sudo find / -name pg_hba.conf -print -quit|head -1`
sudo -u postgres sed -ibak 's/postgres/all/gi' $pg_hba
sudo -u postgres sed -ibak 's/peer/trust/gi' $pg_hba
sudo -u postgres sed -ibak 's/md5/trust/gi' $pg_hba
sudo service postgresql restart
sudo -u postgres -i psql -c 'CREATE EXTENSION hstore;'
sudo -u postgres -i psql -c 'CREATE USER vagrant WITH SUPERUSER CREATEROLE CREATEDB;'
sudo -u postgres -i psql -c 'CREATE USER root WITH SUPERUSER CREATEROLE CREATEDB;'

# 7.Create all databases
echo ''
echo '******************************************************'
echo '****** STEP 7 of 10 ***** Creating TimeOverflow Databases (development,test,production)'
echo '******************************************************'
echo ''
rake db:create RAILS_ENV=development
rake db:create RAILS_ENV=test
rake db:create RAILS_ENV=production

# 8.Grant privileges to user vagrant
echo ''
echo '******************************************************'
echo '****** STEP 8 of 10 ***** Granting privileges to User vagrant on these databases'
echo '******************************************************'
echo ''
sudo -u postgres -i psql -c 'GRANT ALL PRIVILEGES ON DATABASE timeoverflow_development to vagrant;'
sudo -u postgres -i psql -c 'GRANT ALL PRIVILEGES ON DATABASE timeoverflow_test to vagrant;'
sudo -u postgres -i psql -c 'GRANT ALL PRIVILEGES ON DATABASE timeoverflow_production to vagrant;'
sudo -u postgres -i psql -c 'GRANT ALL PRIVILEGES ON DATABASE timeoverflow_development to root;'
sudo -u postgres -i psql -c 'GRANT ALL PRIVILEGES ON DATABASE timeoverflow_test to root;'
sudo -u postgres -i psql -c 'GRANT ALL PRIVILEGES ON DATABASE timeoverflow_production to root;'

# 9.Run DB migrations
echo ''
echo '******************************************************'
echo '****** STEP 9 of 10 ***** Running Databases Migrations'
echo '******************************************************'
echo ''
rake db:migrate RAILS_ENV=development
rake db:migrate RAILS_ENV=test
rake db:migrate RAILS_ENV=production

# 10.Run DB seeds
echo ''
echo '******************************************************'
echo '****** STEP 9 of 10 ***** Running Database Seeds'
echo '******************************************************'
echo ''
rake db:seed RAILS_ENV=development
rake db:seed RAILS_ENV=test
rake db:seed RAILS_ENV=production

# 12.Inform we are DONE!
echo ''
echo '********************** DONE! *************************'
echo 'Vagrant image for TimeOverflow development provisioned! :)'
echo "Date of provisioning saved at /etc/vagrant_provisioned_at file"
echo '******************************************************'
echo ''
echo '******************* IMPORTANT ******************'
echo 'Please remember to finish your git configuration'
echo ''
echo 'Configure your user.name and user.email that will show in Github'
echo '$ git config --global user.email "your@email.com"'
echo '$ git config --global user.name "Your name"'
echo '******************* IMPORTANT *****************'
echo ''
echo '**************'
echo 'What is next?'
echo '**************'
echo '1. launch a session of the TimeOverflow Vagrant image and go to /vagrant folder'
echo '   NOTE: /vagrant folder is a shared folder with your host where TimeOverflow code resides'
echo '   $ vagrant ssh'
echo '   $ cd /vagrant'
echo '2. Then develop using your host editor.'
echo '3. Run TimeOverflow by doing'
echo '   $ cd /vagrant'
echo '   $ rails s'
echo 'As we are doing port forwarding for 3000 you can access the running app from your browser at http://localhost:3000'
echo ''
echo '4. For commits and other GIT commands: You can use GIT from vagrant ssh session or from your host computer'
echo '   If using Windows host machine use GIT from vagrant ssh session'
echo ''
echo 'For more details visit the TimeOverflow Wiki at Github, specially following links'
echo 'https://github.com/coopdevs/timeoverflow/wiki/Getting-started'
echo 'https://github.com/coopdevs/timeoverflow/wiki/Configuring-Postgres-to-Avoid-using-environment-variables'
echo ''
echo ''
echo '******************************************************'
echo "Vagrant image provisioning finished at "
date
date >> /etc/vagrant_provisioned_at
echo '******************************************************'
