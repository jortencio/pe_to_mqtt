# Changelog

All notable changes to this project will be documented in this file.

## v0.2.1
**Features**

**Bugfixes**
* Fix error while running Puppet node clean/purge [#14](https://github.com/jortencio/pe_to_mqtt/issues/13)
* Added logic to prevent Puppet runs from failing when MQTT broker is unavailable

**Known Issues**

## v0.2.0
**Features**
* Added ability to filter fields in Puppet report sent to MQTT Broker
* Added ability to filter facts sent to MQTT Broker
* Updated README limitation notes regarding payloads >500KB getting lost being due to MQTT broker settings rather than module implementation

**Bugfixes**

**Known Issues**

## 0.1.0
**Features**
* Initial Release - Basic configuration of MQTT based fact terminus and report processor

**Bugfixes**

**Known Issues**
* There may be some issues publishing facts/report data that is > 500 KB.  This behaviour has been noticed for Puppet Primary Server/Compiler reports where reports published to the MQTT Broker seem to get lost when they are greater than 500 KB. (Future plans to add settings for controlling the report payload in the future which can help control payload size)
