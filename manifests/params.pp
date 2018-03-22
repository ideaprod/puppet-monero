# == Class: monero::params
#
# This is a container class with default parameters for monero classes.
class monero::params {
  $config_dir              = '/etc/monero'
  $data_dir                = '/var/lib/monero'
  $group                   = 'monero'
  $log_dir                 = '/var/log/monero'
  $log_level               = 0
  $monerod_config_file     = 'monerod.conf'
  $monerod_log_file        = 'monerod.log'
  $monerod_service_name    = 'monerod'
  $service_enable          = true
  $service_ensure          = 'running'
  $service_manage          = true
  $user                    = 'monero'
  $wallet_name             = 'MyWallet'
  $wallet_password         = 'MyPassw0rd'
  $wallet_rpc_log_file     = 'monero-wallet-rpc.log'
  $wallet_rpc_config_file  = 'monero-wallet-rpc.conf'
  $wallet_rpc_service_name = 'monero-wallet-rpc'

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
