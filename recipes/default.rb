#
# Cookbook Name:: gerrit
# Recipe:: default
#
# Copyright 2013, Mathew Odden
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_recipe "database::mysql"

# install Git (Gerrit expects it)
include_recipe "git"

# install RHEL6 openjdk6
include_recipe "java::openjdk"

# install/setup reverse proxy
if node['gerrit']['proxy']
  include_recipe "gerrit::proxy"
end

# install gitweb
if node['gerrit']['gitweb']
  package "gitweb"
end

gerrit_user_name = node['gerrit']['user']

# setup group for user
group gerrit_user_name

# setup gerrit user
user gerrit_user_name do
  gid gerrit_user_name
  home node['gerrit']['home']
  comment "Gerrit Code Review"
  shell "/bin/bash"
  system true
end

# chown homedir
directory node['gerrit']['home'] do
  owner gerrit_user_name
  group gerrit_user_name
end

### DB Setup ###
gerrit_db_name = node['gerrit']['database']['name']
gerrit_db_user = node['gerrit']['database']['user']
conn_info = {:host => "localhost",
             :username => "root",
             :password => node['mysql']['server_root_password']}

mysql_database gerrit_db_name do
  connection conn_info
  action :create
end

# set database character set
mysql_database "query-update-character-set" do
  connection conn_info
  database_name gerrit_db_name
  action :query
  sql "ALTER DATABASE #{gerrit_db_name} charset=latin1"
end

# in MySQL, GRANT creates the user as well
mysql_database_user gerrit_db_user do
  connection conn_info
  database_name gerrit_db_name
  password node['gerrit']['database']['password']
  privileges [ :all ]
  action :grant
end

mysql_database "flush-privileges" do
  connection conn_info
  action :query
  sql "FLUSH PRIVILEGES"
end 

### Gerrit Setup ###

# directory for config files
directory "#{node['gerrit']['home']}/etc" do
  owner gerrit_user_name
  group gerrit_user_name
  recursive true
end

# configuration files
config_file = node['gerrit']['config_template']
template "#{node['gerrit']['home']}/etc/gerrit.config" do
  source "gerrit/#{config_file}"
  owner gerrit_user_name
  group gerrit_user_name
  mode 0644
  notifies :restart, "service[gerrit]"
end

template "#{node['gerrit']['home']}/etc/replication.config" do
  source "gerrit/replication.config.erb"
  owner gerrit_user_name
  group gerrit_user_name
  mode 0644
  notifies :restart, "service[gerrit]"
end

template "#{node['gerrit']['home']}/etc/secure.config" do
  source "gerrit/secure.config.erb"
  owner gerrit_user_name
  group gerrit_user_name
  mode 0600
  notifies :restart, "service[gerrit]"
end

# provide GERRIT_SITE variable to init.d script
template "/etc/default/gerritcodereview" do
  source "system/default.gerritcodereview.erb"
  mode 0644
  notifies :restart, "service[gerrit]"
end

# download war file
war_file_name = "#{node['gerrit']['home']}/gerrit.war"
remote_file war_file_name do
  owner gerrit_user_name
  source node['gerrit']['download_url']
  notifies :run, "bash[gerrit-init]", :immediately
  action :create_if_missing
end

# nudge Gerrit to run its init
bash "gerrit-init" do
  user gerrit_user_name
  group gerrit_user_name
  cwd "#{node['gerrit']['home']}"
  code "java -jar #{war_file_name} init --batch --no-auto-start -d #{node['gerrit']['home']}"
  action :nothing
  notifies :restart, "service[gerrit]"
end

# setup service and init scripts
link "/etc/init.d/gerrit" do
  to "#{node['gerrit']['home']}/bin/gerrit.sh"
end

link "/etc/rc3.d/S90gerrit" do
  to "../init.d/gerrit"
end

service "gerrit" do
  supports :status => true, :restart => true, :reload => true
  status_command "/etc/init.d/gerrit check"
  action [ :enable, :start ]
end

# firewall setup
include_recipe "gerrit::firewall"

# cronjobs
include_recipe "gerrit::cron"
