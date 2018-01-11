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
  $service_name   = 'monerod'
  $user           = 'monero'

  # <OS family handling>
  case $::osfamily {
    'Debian': {
      case $::operatingsystem {
        'Debian': {
          case $::operatingsystemrelease {
            /^8/: {
            }
            default: {
              fail("monero supports Debian 8 (jessie). Detected \
operatingsystemrelease is <${::operatingsystemrelease}>.")
            }
          }
        }
        'Ubuntu': {
          case $::operatingsystemrelease {
            /^16.04/: {
            }
            default: {
              fail("monero supports Ubuntu 16.04 (xenial). Detected \
operatingsystemrelease is <${::operatingsystemrelease}>.")
            }
          }
        }
        default: {
          fail("monero supports Debian and Ubuntu. Detected operatingsystem is \
<${::operatingsystem}>.")
        }
      }
    }
    default: {
      fail("monero supports osfamilies Debian. Detected osfamily is <${::osfamily}>.")
    }
  }
  # </OS family handling>
}
