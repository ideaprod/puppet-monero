# Private class
class monero::config inherits monero {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  file { 'monero_data_dir':
    ensure => directory,
    path   => $monero::data_dir,
    owner  => $monero::user,
    group  => $monero::group,
    mode   => '0755',
  }

  if $monero::config_dir != '/etc' {
    file { 'monero_config_dir':
      ensure => directory,
      path   => $monero::config_dir,
      owner  => $monero::user,
      group  => $monero::group,
      mode   => '0755',
    }
  }

  file { 'monero_config':
    ensure  => file,
    path    => "${monero::config_dir}/${monero::config_file}",
    owner   => $monero::user,
    group   => $monero::group,
    mode    => '0644',
    content => template('monero/monerod.conf.erb'),
    notify  => Service['monerod'],
  }
}
