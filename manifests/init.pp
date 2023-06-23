# @summary A class that configures the report_mqtt Puppet report processor and/or mqtt terminus on Puppetservers
#
# Configures an mqtt report processor and/or mqtt fact terminus on Puppet servers
# 
# @param mqtt_hostname
# 
#   Hostname of the mqtt broker
#
# @param mqtt_port
# 
#   Port for mqtt client connection to MQTT broker
#
# @param disable_report_mqtt
# 
#   Parameter to disable the mqtt report processor
#
# @param publish_status
# 
#   Parameter for controlling which reports to publish
#
# @example
#   include pe_to_mqtt
class pe_to_mqtt (
  String                                     $mqtt_hostname,
  Integer                                    $mqtt_port,
  Boolean                                    $disable_report_mqtt,
  Enum['all','changed','unchanged','failed'] $publish_status,
) {
  # Install the mqtt gem
  package { 'mqtt':
    ensure   => present,
    provider => puppetserver_gem,
  }

  # Add report processor to Puppet.conf
  ini_subsetting { 'enable report_mqtt':
    ensure               => present,
    path                 => "${settings::confdir}/puppet.conf",
    section              => 'master',
    setting              => 'reports',
    subsetting           => 'report_mqtt',
    subsetting_separator => ',',
    notify               => Service['pe-puppetserver'],
  }

  # Config file for report_mqtt
  file { "${settings::confdir}/report_mqtt.yaml":
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0640',
    content => epp('pe_to_mqtt/report_mqtt.yaml.epp'),
  }
}
