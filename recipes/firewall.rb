#
# Cookbook Name:: gerrit
# Recipe:: firewall
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

bash "create-gerrit-input" do
  not_if "iptables -L | grep gerrit-input"
  code "iptables -N gerrit-input"
end

bash "ensure-gerrit-input" do
  not_if "iptables -L INPUT | grep gerrit-input"
  code "iptables -I INPUT 1 -j gerrit-input"
end

bash "build-gerrit-input" do
  code "iptables -F gerrit-input && " + 
       "iptables -A gerrit-input -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT && " +
       "iptables -A gerrit-input -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT && " +
       "iptables -A gerrit-input -p tcp -m state --state NEW -m tcp --dport 29418 -j ACCEPT"
end

bash "iptables-save" do
  code "/etc/init.d/iptables save"
end
