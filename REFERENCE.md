# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

* [`pe_to_mqtt`](#pe_to_mqtt): A class that configures the report_mqtt Puppet report processor and/or mqtt terminus on Puppetservers

## Classes

### <a name="pe_to_mqtt"></a>`pe_to_mqtt`

Configures an mqtt report processor and/or mqtt fact terminus on Puppet servers

#### Examples

##### 

```puppet
include pe_to_mqtt
```

#### Parameters

The following parameters are available in the `pe_to_mqtt` class:

* [`manage_mqtt_gem`](#-pe_to_mqtt--manage_mqtt_gem)
* [`configure_report_processor`](#-pe_to_mqtt--configure_report_processor)
* [`manage_route_file`](#-pe_to_mqtt--manage_route_file)
* [`mqtt_hostname`](#-pe_to_mqtt--mqtt_hostname)
* [`mqtt_port`](#-pe_to_mqtt--mqtt_port)
* [`disable_report_mqtt`](#-pe_to_mqtt--disable_report_mqtt)
* [`report_publish_status`](#-pe_to_mqtt--report_publish_status)
* [`report_mqtt_topic`](#-pe_to_mqtt--report_mqtt_topic)
* [`report_selected_fields`](#-pe_to_mqtt--report_selected_fields)
* [`disable_facts_mqtt`](#-pe_to_mqtt--disable_facts_mqtt)
* [`facts_terminus`](#-pe_to_mqtt--facts_terminus)
* [`facts_cache_terminus`](#-pe_to_mqtt--facts_cache_terminus)
* [`facts_mqtt_topic`](#-pe_to_mqtt--facts_mqtt_topic)
* [`facts_selected_facts`](#-pe_to_mqtt--facts_selected_facts)

##### <a name="-pe_to_mqtt--manage_mqtt_gem"></a>`manage_mqtt_gem`

Data type: `Boolean`

Boolean for setting whether to manage the required mqtt gem on Puppet server.

Default value: `true`

##### <a name="-pe_to_mqtt--configure_report_processor"></a>`configure_report_processor`

Data type: `Boolean`

Boolean for setting whether to configure puppet.conf to make use of mqtt report processor.

Default value: `true`

##### <a name="-pe_to_mqtt--manage_route_file"></a>`manage_route_file`

Data type: `Boolean`

Boolean for setting whether to create a new route_file and update puppet.conf to use it.

Default value: `true`

##### <a name="-pe_to_mqtt--mqtt_hostname"></a>`mqtt_hostname`

Data type: `String`

Hostname of the mqtt broker.

Default value: `'mqtt.example.com'`

##### <a name="-pe_to_mqtt--mqtt_port"></a>`mqtt_port`

Data type: `Integer`

Port for mqtt client connection to MQTT broker.

Default value: `1883`

##### <a name="-pe_to_mqtt--disable_report_mqtt"></a>`disable_report_mqtt`

Data type: `Boolean`

Parameter to disable the mqtt report processor from publishing to mqtt.

Default value: `false`

##### <a name="-pe_to_mqtt--report_publish_status"></a>`report_publish_status`

Data type: `Enum['all','changed','unchanged','failed']`

Parameter for controlling which reports to publish based on report status.

Default value: `'all'`

##### <a name="-pe_to_mqtt--report_mqtt_topic"></a>`report_mqtt_topic`

Data type: `String`

MQTT topic to publish reports to.

Default value: `'puppet/reports'`

##### <a name="-pe_to_mqtt--report_selected_fields"></a>`report_selected_fields`

Data type:

```puppet
Optional[Array[Enum[
        'host',
        'time',
        'configuration_version',
        'transaction_uuid',
        'report_format',
        'puppet_version',
        'status',
        'transaction_completed',
        'noop',
        'noop_pending',
        'environment',
        'logs',
        'metrics',
        'resource_statuses',
        'corrective_change',
        'server_used',
        'catalog_uuid',
        'code_id',
        'job_id',
        'cached_catalog_status',
  ]]]
```

An optional array of facts to select.  If not defined, all facts will be selected.

Default value: `undef`

##### <a name="-pe_to_mqtt--disable_facts_mqtt"></a>`disable_facts_mqtt`

Data type: `Boolean`

Parameter for controlling which reports to publish based on report status.

Default value: `false`

##### <a name="-pe_to_mqtt--facts_terminus"></a>`facts_terminus`

Data type: `String`

The mqtt facts terminus to set in route_file.

Default value: `'mqtt'`

##### <a name="-pe_to_mqtt--facts_cache_terminus"></a>`facts_cache_terminus`

Data type: `String`

The mqtt facts cache terminus to set in route_file.

Default value: `'json'`

##### <a name="-pe_to_mqtt--facts_mqtt_topic"></a>`facts_mqtt_topic`

Data type: `String`

MQTT topic to publish facts to.

Default value: `'puppet/facts'`

##### <a name="-pe_to_mqtt--facts_selected_facts"></a>`facts_selected_facts`

Data type: `Optional[Array[String[1]]]`

An optional array of facts to select.  If not defined, all facts will be selected.

Default value: `undef`

