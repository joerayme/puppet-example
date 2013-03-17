define nginx::site($domain,
                   $root,
                   $ensure=present,
                   $owner=undef,
                   $group=undef,
                   $mediaroot="",
                   $mediaprefix="",
                   $default_vhost=false,
                   $autoindex=false,
                   $rewrite_missing_html_extension=false,
                   $upstreams=[],
                   $aliases=[],
                   $ssl=false,
                   $ssl_certificate="",
                   $ssl_certificate_key="",
                   $conf="",
                   $env="live") {

  $absolute_mediaroot = inline_template("<%= File.expand_path(mediaroot, root) %>")

  if $ensure == 'present' {
    # Parent directory of root directory. /var/www for /var/www/blog
    $root_parent = inline_template("<%= root.match(%r!(.+)/.+!)[1] %>")

    if !defined(File[$root_parent]) {
      file { $root_parent:
        ensure => directory,
        owner => $owner,
        group => $group,
      }
    }

  } elsif $ensure == 'absent' {

    file { $root:
      ensure => $ensure,
      owner => $owner,
      group => $group,
      recurse => true,
      purge => true,
      force => true,
    }
  }

  file {
    "/etc/nginx/sites-available/${name}.conf":
      ensure => $ensure,
      content => multi_source_template("nginx/$conf.conf.erb", "nginx/$name.conf.erb", "nginx/site.conf.erb"),
      require => Package[nginx],
      notify => Service[nginx];

    "/etc/nginx/sites-enabled/${name}.conf":
      ensure => $ensure ? {
        'present' => link,
        'absent' => $ensure,
      },
      target => $ensure ? {
        'present' => "/etc/nginx/sites-available/${name}.conf",
        'absent' => notlink,
      },
      require => File["/etc/nginx/sites-available/${name}.conf"],
      notify => Service[nginx];
  }
}
