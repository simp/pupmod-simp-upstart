[![License](https://img.shields.io/:license-apache-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0.html)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/73/badge)](https://bestpractices.coreinfrastructure.org/projects/73)
[![Puppet Forge](https://img.shields.io/puppetforge/v/simp/upstart.svg)](https://forge.puppetlabs.com/simp/upstart)
[![Puppet Forge Downloads](https://img.shields.io/puppetforge/dt/simp/upstart.svg)](https://forge.puppetlabs.com/simp/upstart)
[![Build Status](https://travis-ci.org/simp/pupmod-simp-upstart.svg)](https://travis-ci.org/simp/pupmod-simp-upstart)

# Module


#### Table of Contents
1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with upstart](#setup)
    * [What upstart affects](#what-upstart-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with upstart](#beginning-with-upstart)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Acceptance Tests](#acceptance-tests)


## Module Description

Upstart is an event-based replacement for the /sbin/init daemon which handles
starting of tasks and services during boot, stopping them during shutdown and
supervising them while the system is running.

This class allows for configuration of upstart init files. The main class will
ensure that /etc/init has proper permissions and disable ctrl+alt+del restarts
by default.

`upstart::job` allows you to manage upstart jobs in /etc/init.

## Setup

Include `SIMP/upstart` in your modulepath.

### What upstart affects

This module will manage the /etc/init directory, and any additional jobs created
by `upstart::job`

### Begging with upstart

To ensure the proper permissions on /etc/init and disable ctrl+alt+delete
restart, just include the main class in your manifest.

```puppet
include upstart
```

## Usage


### I want to re-enable ctrl+alt+delete restarts

```puppet
class{'upstart':
  disable_ctrl_alt_del => false,
}
```

### I want to run a script at restart on any run-level

```puppet
upstart::job { 'myjob':
  main_process_type => 'script',
  main_process      => template('myprofile/script'),
  start_on          => 'runlevel [0123456]',
  description       => 'Used to run my process'
}
```

### I have a simple command I want to run on runlevel 5

```puppet
upstart::job { 'myjob':
  main_process_type => 'script',
  main_process      => '/bin/foo --opt -xyz foo bar',
  start_on          => 'runlevel [5]',
  description       => 'Used to foo xyz options on foo and bar',
}
```

## Reference


### Public Classes
* [upstart](https://github.com/simp/pupmod-simp-upstart/blob/master/manifests/init.pp): Manages /etc/init and controls the ctrl+alt+delete job.

### Defined Types
* [upstart::job](https://github.com/simp/pupmod-simp-upstart/blob/master/manifests/job.pp): Manages upstart jobs

## Limitations

SIMP Puppet modules are generally intended to be used on a Red Hat Enterprise
Linux-compatible distribution.

## Development

Please read our [Contribution Guide](http://simp-doc.readthedocs.io/en/stable/contributors_guide/index.html).

If you find any issues, they can be submitted to our
[JIRA](https://simp-project.atlassian.net).


## Acceptance tests

To run the system tests, you need `Vagrant` installed.

You can then run the following to execute the acceptance tests:

```shell
   bundle exec rake beaker:suites
```

Some environment variables may be useful:

```shell
   BEAKER_debug=true
   BEAKER_provision=no
   BEAKER_destroy=no
   BEAKER_use_fixtures_dir_for_modules=yes
```

*  ``BEAKER_debug``: show the commands being run on the STU and their output.
*  ``BEAKER_destroy=no``: prevent the machine destruction after the tests
   finish so you can inspect the state.
*  ``BEAKER_provision=no``: prevent the machine from being recreated.  This can
   save a lot of time while you're writing the tests.
*  ``BEAKER_use_fixtures_dir_for_modules=yes``: cause all module dependencies
   to be loaded from the ``spec/fixtures/modules`` directory, based on the
   contents of ``.fixtures.yml``. The contents of this directory are usually
   populated by ``bundle exec rake spec_prep``. This can be used to run
   acceptance tests to run on isolated networks.
