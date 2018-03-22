# Private class
class monero::service inherits monero {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $monero::service_manage_bool {
    systemd::unit_file { 'monerod.service':
      content => template('monero/monerod.service.erb'),
    }
    ~> service { 'monerod':
      ensure     => $monero::service_ensure,
      name       => $monero::monerod_service_name,
      enable     => $monero::service_enable,
      hasrestart => true,
      subscribe  => File['monerod_config_file'],
    }
    -> logrotate::rule { 'monerod':
      path          => "${monero::log_dir}/${monero::monerod_log_file}",
      compress      => true,
      create        => true,
      create_mode   => '640',
      create_owner  => 'root',
      create_group  => 'adm',
      delaycompress => true,
      ifempty       => false,
      rotate        => 52,
      rotate_every  => 'week',
      sharedscripts => true,
      postrotate    => 'systemctl restart monerod.service',
    }

    systemd::unit_file { 'monero-wallet-rpc.service':
      content => template('monero/monero-wallet-rpc.service.erb'),
    }
    ~> service { 'wallet_rpc':
      ensure     => $monero::service_ensure,
      name       => $monero::wallet_rpc_service_name,
      enable     => $monero::service_enable,
      hasrestart => true,
      subscribe  => File['wallet_rpc_config_file'],
    }
    -> logrotate::rule { 'monero-wallet-rpc':
      path          => "${monero::log_dir}/${monero::wallet_rpc_log_file}",
      compress      => true,
      create        => true,
      create_mode   => '640',
      create_owner  => 'root',
      create_group  => 'adm',
      delaycompress => true,
      ifempty       => false,
      rotate        => 52,
      rotate_every  => 'week',
      sharedscripts => true,
      postrotate    => 'systemctl restart monero-wallet-rpc.service',
    }
  }
}
