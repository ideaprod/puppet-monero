# Private class
class monero::service inherits monero {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $monero::service_manage_bool {
    file { '/lib/systemd/system/monerod.service':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('monero/monerod.service.erb'),
    }->
    service { 'monero':
      ensure     => $monero::service_ensure,
      name       => $monero::service_name,
      enable     => $monero::service_enable,
      hasrestart => true,
      subscribe  => [
        File['monero_config'],
      ],
    }
  }
}
