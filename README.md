# monero

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Contributors](#contributors)

## Overview

Puppet module to manage Monero installation and configuration.

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

##### `config_file`

Specifies a path to the main config file. Valid options: string. Default value: varies with operating system

##### `config_dir`

Specifies a path to the config directory. Valid options: string. Default value: varies with operating system

##### `log_file`

Specifies the logfile directive value. Valid options: string. Default value: '/var/log/monero.log'

##### `user`

Specifies the user to connect to the remote M/Monero server. Valid options: string. Default value: 'monero'

##### `service_ensure`

Tells Puppet whether the Monero service should be running. Valid options: 'running' or 'stopped'. Default value: 'running'

##### `service_manage`

Tells Puppet whether to manage the Monero service. Valid options: 'true' or 'false'. Default value: 'true'

##### `service_name`

Tells Puppet what Monero service to manage. Valid options: string. Default value: 'monero'

## Limitations

Debian family OSes are officially supported. Tested and built on Debian.

## Development

[Ideaprod](http://www.ideaprod.com) modules on the Puppet Forge are open projects, and community contributions are essential for keeping them great.

[Fork this module on GitHub](https://github.com/ideaprod/puppet-monero/fork)

## Contributors

The list of contributors can be found at: https://github.com/ideaprod/puppet-monero/graphs/contributors
