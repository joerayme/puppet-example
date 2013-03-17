# Set up some variables
$mysql_user     = 'example'
$mysql_password = 's3cur3p4ss'
$mysql_database = 'example'

# Execute apt-get update before requiring packages
exec { "apt-update":
  command => "/usr/bin/apt-get update"
}
Exec["apt-update"] -> Package <| |>

# Ensure the vhost exists but install php5-fpm first
include nginx
nginx::site { 'local.example.com':
  domain  => 'local.example.com',
  root    => '/data/local.example.com/htdocs',
  require => Package['php5-fpm'],
}

# Install the required PHP packages
package { 'php5-fpm':
  ensure => 'present',
}
service { 'php5-fpm':
  hasrestart => true,
  ensure     => 'running',
  require    => Package['php5-fpm'],
}
package { 'php5-mysql':
  ensure => 'present',
  require => Package['php5-fpm'],
  notify  => Service['php5-fpm'],
}

# Install MySQL client and server
class { 'mysql':
  require => Class['mysql::server'],
}
class {'mysql::server':}
# Configure the bits of MySQL we want
database { $mysql_database:
  ensure  => 'present',
  charset => 'utf8',
  require => Class['mysql::server'],
}
database_user { "${mysql_user}@localhost":
  password_hash => mysql_password($mysql_password),
  require => Class['mysql::server'],
}
database_grant { "${mysql_user}@localhost/${mysql_database}":
  privileges => ['all'],
  require    => [Database[$mysql_database], Database_user["${mysql_user}@localhost"], Class['mysql::server']],
}

# Set up the database settings file in our application
# You'd probably want to set the owner to www-data here but because we're mounting using Vagrant we don't need to
file { '/data':
  ensure => 'directory',
  owner  => 'root',
  group  => 'root',
  mode   => 0755,
}
file { '/data/config':
  ensure => 'directory',
  owner  => 'root',
  group  => 'root',
  mode   => 0755,
}
file { '/data/config/example.com-settings.ini':
  ensure  => 'present',
  mode    => 0644,
  owner   => 'root',
  group   => 'root',
  content => inline_template("
[database]
database = <%= mysql_database %>
user = <%= mysql_user %>
password = <%= mysql_password %>
")
}