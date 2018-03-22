# monero

[![Build Status](https://travis-ci.org/ideaprod/puppet-monero.svg?branch=master)](https://travis-ci.org/ideaprod/puppet-monero)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Usage - Configuration options and additional functionality](#usage)
3. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)
6. [Contributors](#contributors)

## Module Description

This module installs and configures [Monero](https://getmonero.org/).

## Usage

```puppet
include ::monero
```

## Reference

### Classes

#### Public classes

* monero: Main class, includes all other classes.

#### Private classes

* monero::params: Sets parameter defaults per operating system.
* monero::install: Handles the packages.
* monero::config: Handles the configuration file.
* monero::service: Handles the service.

#### Parameters

The following parameters are available in the `::monero` class:

##### `config_dir`

Specifies the config directory path. Valid options: string. Default value: '/etc/monero'

##### `data_dir`

Specifies the data directory path. Valid options: string. Default value: '/var/lib/monero'

##### `group`

Specifies the Unix group to launch monerod and monero-wallet-rpc. Valid options: string. Default value: 'monero'

##### `log_dir`

Specifies the log directory path. Valid options: absolute path. Default value: '/var/log/monero'

##### `log_level`

Specifies the log level. Valid options: integer. Default value: '0'

##### `monerod_config_file`

Specifies a path to the monerod config file. Valid options: string. Default value: 'monerod.conf'

##### `monerod_log_file`

Specifies the monerod log filename. Valid options: string. Default value: 'monerod.log'

##### `monerod_service_name`

Tells Puppet what monerod service to manage. Valid options: string. Default value: 'monerod'

##### `service_ensure`

Tells Puppet whether the Monero services should be running. Valid options: 'running' or 'stopped'. Default value: 'running'

##### `service_manage`

Tells Puppet whether to manage the Monero services. Valid options: 'true' or 'false'. Default value: 'true'

##### `user`

Specifies the Unix user to launch monerod and monero-wallet-rpc. Valid options: string. Default value: 'monero'

##### `wallet_rpc_config_file`

Specifies a path to the Wallet RPC config file. Valid options: string. Default value: 'monero-wallet-rpc.conf'

##### `wallet_rpc_log_file`

Specifies the Wallet RPC log filename. Valid options: string. Default value: 'monero-wallet-rpc.log'

##### `service_name`

Tells Puppet what Monero Wallet RPC service to manage. Valid options: string. Default value: 'monero-wallet-rpc'

## Limitations

Debian family OSes are officially supported. Tested and built on Debian.

## Development

[Ideaprod](http://www.ideaprod.com) modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great.

[Fork this module on GitHub](https://github.com/ideaprod/puppet-monero/fork)

## Contributors

The list of contributors can be found at: https://github.com/ideaprod/puppet-monero/graphs/contributors
