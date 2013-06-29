#
# Cookbook Name:: gerrit
# Recipe:: proxy
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

include_recipe "apache2"
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"

# disable default site
apache_site "default" do
  enable false
end

if node['gerrit']['ssl_certificate']
  include_recipe "apache2::mod_ssl"
  ssl_cert_path = node['gerrit']['ssl_certificate'] + ".crt"
  ssl_key_path = node['gerrit']['ssl_certificate'] + ".key"
end

web_app node['gerrit']['hostname'] do
  server_name node['gerrit']['hostname']
  server_aliases []
  docroot "/var/www"
  template "apache/web_app_conf.erb"
  ssl_certfile ssl_cert_path
  ssl_keyfile ssl_key_path
end
