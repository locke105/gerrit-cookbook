name             "gerrit"
maintainer       "Mathew Odden"
maintainer_email "locke105@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures Gerrit Code Review"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.3"

depends "cron"
depends "database"
depends "git"
depends "mysql"
depends "java"
depends "apache2"

supports "rhel" "> 6.3"
supports "centos" "> 6.3"
