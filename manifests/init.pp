# == Class: monero
#
class monero (
  $config_file    = $monero::params::config_file,
  $config_dir     = $monero::params::config_dir,
  $data_dir       = $monero::params::data_dir,
  $group          = $monero::params::group,
  $log_dir        = $monero::params::log_dir,
  $log_file       = $monero::params::log_file,
  $log_level      = $monero::params::log_level,
  $service_enable = $monero::params::service_enable,
  $service_ensure = $monero::params::service_ensure,
  $service_manage = $monero::params::service_manage,
  $service_name   = $monero::params::service_name,
  $user           = $monero::params::user,
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
  validate_string($config_file)
  validate_absolute_path($config_dir)
  validate_absolute_path($data_dir)
  validate_string($group)
  validate_absolute_path($log_dir)
  validate_string($log_file)
  validate_integer($log_level)
  validate_bool($service_enable_bool)
  validate_string($service_ensure)
  validate_bool($service_manage_bool)
  validate_string($service_name)
  validate_string($user)
  # </variable validations>

  anchor { "${module_name}::begin": } ->
  class { "${module_name}::install": } ->
  class { "${module_name}::config": } ~>
  class { "${module_name}::service": } ->
  anchor { "${module_name}::end": }
}
