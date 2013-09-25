# vim: set tabstop=2 shiftwidth=2 expandtab:
#
# Cookbook Name:: gerrit
# Recipe:: cron
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

# some things don't come with cron...
include_recipe "cron"

# pack repos every Sunday morning
cron "git_repack" do
  user node['gerrit']['user']
  weekday '0'
  hour '4'
  minute '10'
  command %Q|find #{node['gerrit']['home']} -type d -name "*.git" -print -exec git --git-dir="{}" repack -afd \\;|
end
