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

  file { 'monerod_config_file':
    ensure  => file,
    path    => "${monero::config_dir}/${monero::monerod_config_file}",
    owner   => $monero::user,
    group   => $monero::group,
    mode    => '0644',
    content => template('monero/monerod.conf.erb'),
  }
  file { 'wallet_rpc_config_file':
    ensure  => file,
    path    => "${monero::config_dir}/${monero::wallet_rpc_config_file}",
    owner   => $monero::user,
    group   => $monero::group,
    mode    => '0644',
    content => template('monero/monero-wallet-rpc.conf.erb'),
  }

}
