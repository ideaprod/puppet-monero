# == Class: monero
#
class monero (
  $config_dir              = $monero::params::config_dir,
  $data_dir                = $monero::params::data_dir,
  $group                   = $monero::params::group,
  $log_dir                 = $monero::params::log_dir,
  $log_level               = $monero::params::log_level,
  $monerod_config_file     = $monero::params::monerod_config_file,
  $monerod_log_file        = $monero::params::monerod_log_file,
  $monerod_service_name    = $monero::params::monerod_service_name,
  $service_enable          = $monero::params::service_enable,
  $service_ensure          = $monero::params::service_ensure,
  $service_manage          = $monero::params::service_manage,
  $user                    = $monero::params::user,
  $wallet_name             = $monero::wallet_name,
  $wallet_password         = $monero::wallet_password,
  $wallet_rpc_config_file  = $monero::params::wallet_rpc_config_file,
  $wallet_rpc_log_file     = $monero::params::wallet_rpc_log_file,
  $wallet_rpc_service_name = $monero::params::wallet_rpc_service_name,
) inherits monero::params {
  # <stringified variable handling>
  if is_string($service_enable) == true {
    $service_enable_bool = str2bool($service_enable)
  } else {
    $service_enable_bool = $service_enable
  }

  if is_string($service_manage) == true {
    $service_manage_bool = str2bool($service_manage)
  } else {
    $service_manage_bool = $service_manage
  }
  # </stringified variable handling>

  # <variable validations>
  validate_absolute_path($config_dir)
  validate_absolute_path($data_dir)
  validate_string($group)
  validate_absolute_path($log_dir)
  validate_integer($log_level)
  validate_string($monerod_config_file)
  validate_string($monerod_log_file)
  validate_string($monerod_service_name)
  validate_bool($service_enable_bool)
  validate_string($service_ensure)
  validate_bool($service_manage_bool)
  validate_string($user)
  validate_string($wallet_name)
  validate_string($wallet_password)
  validate_string($wallet_rpc_config_file)
  validate_string($wallet_rpc_log_file)
  validate_string($wallet_rpc_service_name)
  # </variable validations>

  anchor { "${module_name}::begin": }
  -> class { "${module_name}::install": }
  -> class { "${module_name}::config": }
  ~> class { "${module_name}::service": }
  -> anchor { "${module_name}::end": }
}
