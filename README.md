# pe_to_mqtt

A Puppet module that is used for setting up a fact terminus and/or report processor for publishing fact and/or report data respectively from a Puppet Server to an MQTT broker via the MQTT protocol.

>Note: This module has been tested to send data to an EMQX MQTT broker, but should work with other MQTT brokers as well as it is just making using a generic MQTT client.

## Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with pe_to_mqtt](#setup)
    * [What pe_to_mqtt affects](#what-pe_to_mqtt-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with pe_to_mqtt](#beginning-with-pe_to_mqtt)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations](#limitations)
1. [Development - Contributing to the module](#development)

## Description

This Puppet module can be used to configure a Puppet server to send data to a given MQTT broker via the MQTT protocol.

  - Facts data for nodes will by default be published to the topic *puppet/facts*
  - Reports for nodes will by default be published to the topic *puppet/reports*

## Setup

### What pe_to_mqtt affects

This module will manage/install the [mqtt gem][1] on the Puppet server and will configure the following configuration files:

  - *puppet.conf* file to make use of the fact indirector code (via a custom route_file) and report processor code installed via this module.
  - *mqtt_routes.yaml* a custom route_file for setting the facts terminus and facts cache terminus
  - *pe_mqtt.yaml* a configuration file for setting MQTT server details and controlling fact/report data sent to the MQTT broker

### Setup Requirements

 - Puppet Server
 - MQTT Broker (Such as [EMQX][2]. A Puppet module for configuring EMQX can be found [here][3])

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
pe_to_mqtt::report_mqtt_topic: 'puppet/reports'
pe_to_mqtt::facts_terminus: mqtt
pe_to_mqtt::facts_cache_terminus: json
pe_to_mqtt::facts_mqtt_topic: 'puppet/facts'
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

Configure pe_to_mqtt to only send reports to a different MQTT topic:

```yaml
---
pe_to_mqtt::mqtt_hostname: 'mqtt.example.com'
pe_to_mqtt::mqtt_port: 1883
pe_to_mqtt::report_mqtt_topic: 'custom_topic/puppet_reports'
```

Configure pe_to_mqtt to only send select fields of a Puppet report to the MQTT broker (refer to REFERENCE.md for available fields to select or Puppet gem documentation[4]):

```yaml
---
pe_to_mqtt::mqtt_hostname: 'mqtt.example.com'
pe_to_mqtt::mqtt_port: 1883
pe_to_mqtt::report_selected_fields:
  - host
  - time
  - configuration_version
  - transaction_uuid
  - report_format
  - puppet_version
  - status
  - transaction_completed
  - noop
  - noop_pending
  - environment
```

Configure pe_to_mqtt to only send select facts to the MQTT Broker:

```yaml
---
pe_to_mqtt::mqtt_hostname: 'mqtt.example.com'
pe_to_mqtt::mqtt_port: 1883
pe_to_mqtt::facts_selected_facts:
  - os
  - memory
  - puppetversion
  - system_uptime
  - load_averages
  - ipaddress
  - fqdn
```

## Limitations

  - Currently tested on a Puppet Enterprise Installation (PE 2021.7.9/PE 2023.8.0)
  - Only basic configuration is available for MQTT, (e.g. SSL not yet supported).
  - There can be some issues publishing facts/report data that is > 500 KB.  This behaviour has been noticed for Puppet Primary Server/Compiler reports where reports published to the MQTT Broker seem to get lost when they are greater than 500 KB on EMQX.  This is likely to be due to settings on the MQTT broker regarding max size limits for message payloads.

## Development

If you would like to contribute with the development of this module, please feel free to log development changes in the [issues][5] register for this project  

[1]: https://www.rubydoc.info/gems/mqtt
[2]: https://www.emqx.io/
[3]: https://forge.puppet.com/modules/jortencio/emqx
[4]: https://www.rubydoc.info/gems/puppet/Puppet/Transaction/Report
[5]: https://github.com/jortencio/pe_to_mqtt/issues
