# @summary A class that configures the report_mqtt Puppet report processor and/or mqtt terminus on Puppetservers
#
# Configures an mqtt report processor and/or mqtt fact terminus on Puppet servers
# 
# @param manage_mqtt_gem
# 
#   Boolean for setting whether to manage the required mqtt gem on Puppet server.
# 
# @param configure_report_processor
# 
#   Boolean for setting whether to configure puppet.conf to make use of mqtt report processor.
# 
# @param manage_route_file
# 
#   Boolean for setting whether to create a new route_file and update puppet.conf to use it.
# 
# @param mqtt_hostname
# 
#   Hostname of the mqtt broker.
#
# @param mqtt_port
# 
#   Port for mqtt client connection to MQTT broker.
#
# @param disable_report_mqtt
# 
#   Parameter to disable the mqtt report processor from publishing to mqtt.
#
# @param report_publish_status
# 
#   Parameter for controlling which reports to publish based on report status.
#
# @param report_mqtt_topic
# 
#   MQTT topic to publish reports to.
#
# @param report_selected_fields
# 
#   An optional array of facts to select.  If not defined, all facts will be selected.
# 
# @param disable_facts_mqtt
# 
#   Parameter for controlling which reports to publish based on report status.
#
# @param facts_terminus
# 
#   The mqtt facts terminus to set in route_file.
#
# @param facts_cache_terminus
# 
#   The mqtt facts cache terminus to set in route_file.
#
# @param facts_mqtt_topic
# 
#   MQTT topic to publish facts to.
#
# @param facts_selected_facts
# 
#   An optional array of facts to select.  If not defined, all facts will be selected.
#
# @example
#   include pe_to_mqtt
class pe_to_mqtt (
  Boolean                                    $manage_mqtt_gem            = true,
  Boolean                                    $configure_report_processor = true,
  Boolean                                    $manage_route_file          = true,
  String                                     $mqtt_hostname              = 'mqtt.example.com',
  Integer                                    $mqtt_port                  = 1883,
  Boolean                                    $disable_report_mqtt        = false,
  Enum['all','changed','unchanged','failed'] $report_publish_status      = 'all',
  String                                     $report_mqtt_topic          = 'puppet/reports',
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
  ]]]                                        $report_selected_fields     = undef,
  Boolean                                    $disable_facts_mqtt         = false,
  String                                     $facts_terminus             = 'mqtt',
  String                                     $facts_cache_terminus       = 'json',
  String                                     $facts_mqtt_topic           = 'puppet/facts',
  Optional[Array[String[1]]]                 $facts_selected_facts       = undef,
) {
  if $manage_mqtt_gem {
    # Install the mqtt gem in Puppet server Ruby
    package { 'puppet_server_mqtt':
      ensure   => present,
      name     => 'mqtt',
      provider => puppetserver_gem,
    }

    # Install the mqtt gem in Puppet agent Ruby
    package { 'puppet_agent_mqtt':
      ensure   => present,
      name     => 'mqtt',
      provider => puppet_gem,
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
