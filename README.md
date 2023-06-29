# pe_to_mqtt

A Puppet module that is used for setting up a fact terminus and/or report processor for publishing fact and/or report data respectively to an MQTT broker via the MQTT protocol.

>Note: This module has been tested to send data to an EMQX MQTT broker, but should work with other MQTT brokers as well as it is just making using a generic MQTT client.

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with pe_to_mqtt](#setup)
    * [What pe_to_mqtt affects](#what-pe_to_mqtt-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with pe_to_mqtt](#beginning-with-pe_to_mqtt)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This Puppet module can be used to configure a Puppet Enterprise server to send data to a given MQTT broker via to MQTT protocol.

## Setup

### What pe_to_mqtt affects

This module will manage/install the [mqtt gem](https://www.rubydoc.info/gems/mqtt) on the Puppet server and will configure the following configuration files:

  - *puppet.conf* file to make use of the fact indirector code (via a custom route_file) and report processor code installed via this module.
  - *mqtt_routes.yaml* a custom route_file for setting the facts terminus and facts cache terminus
  - *pe_mqtt.yaml* a configuration file for setting MQTT server details and controlling fact/report data sent to the MQTT broker

### Setup Requirements

 - Puppet Enterprise (PE)
 - MQTT Broker (Such as [EMQX][1])

### Beginning with pe_to_mqtt

Basic configuration to set up both the facts terminus and report processor to report to a given MQTT broker, classify the Puppet Primary server with the following:

```puppet
class { 'pe_to_mqtt':
  mqtt_hostname => '<mqtt hostname>',
}
```

## Usage

This module supports the use of Hiera data for setting parameters.  The following is a list of parameters configurable in Hiera: (Please refer to REFERENCE.md for more details)

```yaml
---
pe_to_mqtt::manage_mqtt_gem: true
pe_to_mqtt::configure_report_processor: true
pe_to_mqtt::manage_route_file: true
pe_to_mqtt::mqtt_hostname: 'mqtt.example.com'
pe_to_mqtt::mqtt_port: 1883
pe_to_mqtt::disable_report_mqtt: false
pe_to_mqtt::disable_facts_mqtt: false
pe_to_mqtt::report_publish_status: 'all'
pe_to_mqtt::facts_terminus: mqtt
pe_to_mqtt::facts_cache_terminus: json
```

Common usage:

Classify a node with pe_to_mqtt:

```puppet
include pe_to_mqtt
```

Configure pe_to_mqtt to only configure the fact terminus:

```yaml
---
pe_to_mqtt::configure_report_processor: false
pe_to_mqtt::mqtt_hostname: 'mqtt.example.com'
pe_to_mqtt::mqtt_port: 1883
```

Configure pe_to_mqtt to only configure the fact terminus:

```yaml
---
pe_to_mqtt::mqtt_hostname: 'mqtt.example.com'
pe_to_mqtt::mqtt_port: 1883
pe_to_mqtt::manage_route_file: false
```

Configure pe_to_mqtt to only configure the report processor:

```yaml
---
pe_to_mqtt::configure_report_processor: false
pe_to_mqtt::mqtt_hostname: 'mqtt.example.com'
pe_to_mqtt::mqtt_port: 1883
```

Configure pe_to_mqtt to only send failed reports to MQTT broker:

```yaml
---
pe_to_mqtt::mqtt_hostname: 'mqtt.example.com'
pe_to_mqtt::mqtt_port: 1883
pe_to_mqtt::report_publish_status: 'failed'
```


## Limitations

  - Currently only tested on a Puppet Enterprise Installation
  - Only basic configuration is available for MQTT, (e.g. SSL not yet supported).
  - The report_processor may not be able to send the Puppet primary servers reports to MQTT due to this [issue][2]
  - Unable to filter facts, all facts are sent to MQTT
  - Limitation in the filtering of reports sent to MQTT

## Development

If you would like to contribute with the development of this module, please feel free to log development changes in the [issues][3] register for this project  

[1]: https://www.emqx.io/
[2]: https://github.com/jortencio/pe_to_mqtt/issues/6
[3]: https://github.com/jortencio/pe_to_mqtt/issues
