# @summary A class that configures the report_mqtt Puppet report processor and/or mqtt terminus on Puppetservers
#
# Configures an mqtt report processor and/or mqtt fact terminus on Puppet servers
# 
# @param manage_mqtt_gem
# 
#   Boolean for setting whether to manage the required mqtt gem on Puppet server.  Default: true
# 
# @param configure_report_processor
# 
#   Boolean for setting whether to configure puppet.conf to make use of mqtt report processor.  Default: true
# 
# @param manage_route_file
# 
#   Boolean for setting whether to create a new route_file and update puppet.conf to use it.  Default: true
# 
# @param mqtt_hostname
# 
#   Hostname of the mqtt broker. Default: mqtt.example.com
#
# @param mqtt_port
# 
#   Port for mqtt client connection to MQTT broker.  Default: 1883
#
# @param disable_report_mqtt
# 
#   Parameter to disable the mqtt report processor from publishing to mqtt.  Default: false
#
# @param report_publish_status
# 
#   Parameter for controlling which reports to publish based on report status.  Default: all
#
# @param disable_facts_mqtt
# 
#   Parameter for controlling which reports to publish based on report status.  Default: all
#
# @param facts_terminus
# 
#   The mqtt facts terminus to set in route_file.  Default: mqtt
#
# @param facts_cache_terminus
# 
#   The mqtt facts cache terminus to set in route_file.  Default: json
#
# @example
#   include pe_to_mqtt
class pe_to_mqtt (
  Boolean                                    $manage_mqtt_gem,
  Boolean                                    $configure_report_processor,
  Boolean                                    $manage_route_file,
  String                                     $mqtt_hostname,
  Integer                                    $mqtt_port,
  Boolean                                    $disable_report_mqtt,
  Enum['all','changed','unchanged','failed'] $report_publish_status,
  Boolean                                    $disable_facts_mqtt,
  String                                     $facts_terminus,
  String                                     $facts_cache_terminus
) {
  if $manage_mqtt_gem {
    # Install the mqtt gem
    package { 'mqtt':
      ensure   => present,
      provider => puppetserver_gem,
    }
  }

  # Config file for pe_to_mqtt
  file { "${settings::confdir}/pe_mqtt.yaml":
    ensure  => file,
    owner   => 'pe-puppet',
    group   => 'pe-puppet',
    mode    => '0640',
    content => epp('pe_to_mqtt/pe_mqtt.yaml.epp'),
  }

  if $configure_report_processor {
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
  }

  if $manage_route_file {
    file { "${settings::confdir}/mqtt_routes.yaml":
      ensure  => file,
      owner   => 'pe-puppet',
      group   => 'pe-puppet',
      mode    => '0640',
      content => epp('pe_to_mqtt/mqtt_routes.yaml.epp'),
      notify  => Service['pe-puppetserver'],
    }

    # Modify default route_file in Puppet.conf
    ini_setting { 'change default route_file':
      ensure  => present,
      path    => "${settings::confdir}/puppet.conf",
      section => 'master',
      setting => 'route_file',
      value   => "${settings::confdir}/mqtt_routes.yaml",
      require => File["${settings::confdir}/mqtt_routes.yaml"],
      notify  => Service['pe-puppetserver'],
    }
  }
}
