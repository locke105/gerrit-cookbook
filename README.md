Description
===========

Cookbook to install and configure Gerrit Code Review

For most, the default attributes should be sufficient to get
a working Gerrit install up and running in no time. The cookbook
does assume that you will be using MySQL as your backing database
and does not currently support other DB backends.

Requirements
============

## Platforms

* RHEL
* CentOS

This cookbook was built and tested on CentOS 6.3 and RHEL 6.4

Usage
=====

The default recipe will install Gerrit 2.4.2 and an Apache
server instance to proxy requests to Gerrit. The default setup
is usable out of the box if you put the mysql::server recipe
before gerrit in your node runlist. Some attributes that you may
want to override would be:

* `node['gerrit']['database']['password']` - password for the gerrit user to access the database
* `node['gerrit']['gitweb']` - set to true if you want gitweb support in Gerrit
* `node['gerrit']['smtpServer']` - point Gerrit at your internal SMTP server for email notifications from Gerrit
* `node['gerrit']['ssl_certificate']` - useful for configuring the Apache rproxy to serve Gerrit over HTTPS

There are plenty more tweakables in attributes/default.rb

License and Authors
===================

* Author:: Mathew Odden <locke105@gmail.com>

* Copyright:: 2013, Mathew Odden

Licensed under the Apache License, Version 2.0 (the 'License');
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an 'AS IS' BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
