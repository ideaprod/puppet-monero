# == Class: monero::params
#
# This is a container class with default parameters for monero classes.
class monero::params {
  $config_file    = 'monerod.conf'
  $config_dir     = '/etc'
  $data_dir       = '/var/lib/monero'
  $group          = 'monero'
  $log_dir        = '/var/log/monero'
  $log_file       = 'monero.log'
  $log_level      = 0
  $service_enable = true
  $service_ensure = 'running'
  $service_manage = true
  $service_name   = 'monero'
  $user           = 'monero'

  # <OS family handling>
  case $::osfamily {
    'Debian': {
      case $::lsbdistcodename {
        'jessie', 'xenial': {
        }
        default: {
          fail("monero supports 8 (jessie) and Ubuntu 16.04 (xenial). \
Detected lsbdistcodename is <${::lsbdistcodename}>.")
        }

      }
    }
    default: {
      fail("monero supports osfamilies Debian. Detected osfamily is <${::osfamily}>.")
    }
  }
  # </OS family handling>
}
