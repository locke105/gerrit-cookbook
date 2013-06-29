#
# Cookbook Name:: gerrit
# Attributes:: default
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

default['gerrit']['home'] = "/home/gerrit"
default['gerrit']['user'] = "gerrit"

default['gerrit']['version'] = "2.4.2"
default['gerrit']['download_url'] = "https://gerrit.googlecode.com/files/gerrit-#{node['gerrit']['version']}.war"

default['gerrit']['hostname'] = node['fqdn']
default['gerrit']['canonicalWebUrl'] = "http://#{node['gerrit']['hostname']}/"

# attribute for dropping in custom gerrit.config templates
# this is useful for larger auth configurations such as LDAP
default['gerrit']['config_template'] = "gerrit.config.erb"

default['gerrit']['smtpServer'] = "127.0.0.1"

# proxy stuff
default['gerrit']['proxy'] = true
default['gerrit']['ssl_certificate'] = nil

# database stuff
default['gerrit']['database']['host'] = "localhost"
default['gerrit']['database']['name'] = "reviewdb"
default['gerrit']['database']['user'] = "gerrit"
default['gerrit']['database']['password'] = "gerrit"

# gitweb integration off by default
default['gerrit']['gitweb'] = nil
if node.platform_family?(:rhel)
  default['gerrit']['gitweb_path'] = "/var/www/git/gitweb.cgi"
else
  default['gerrit']['gitweb_path'] = "/usr/lib/cgi-bin/gitweb.cgi"
end
