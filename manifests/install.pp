# Private class
class monero::install inherits monero {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  group { $monero::group:
    ensure => present,
    system => true,
  }->
  user { $monero::user:
    ensure  => present,
    comment => 'Monero Daemon',
    gid     => $monero::group,
    home    => $data_dir,
    shell   => '/bin/false',
    system  => true,
  }

  include '::archive'

  archive { '/tmp/monero-linux-x64-v0.11.1.0.tar.bz2':
    ensure       => present,
    extract      => true,
    extract_path => '/opt',
    source       => 'https://github.com/monero-project/monero/releases/download/v0.11.1.0/monero-linux-x64-v0.11.1.0.tar.bz2',
    creates      => '/opt/monero-v0.11.1.0',
    cleanup      => true,
  }

  file { '/run/monero':
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0755',
  }
  file { '/var/log/monero':
    ensure => directory,
    owner  => $user,
    group  => $group,
    mode   => '0755',
  }
}
