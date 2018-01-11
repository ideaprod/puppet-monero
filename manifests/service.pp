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
      name       => $monero::service_name,
      enable     => $monero::service_enable,
      hasrestart => true,
      subscribe  => File['monero_config'],
    }
  }
}
