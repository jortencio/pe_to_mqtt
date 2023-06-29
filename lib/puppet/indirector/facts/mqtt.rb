# frozen_string_literal: true

require 'puppet/indirector/facts/puppetdb'
require 'mqtt'
require 'yaml'

# mqtt.rb
class Puppet::Node::Facts::Mqtt < Puppet::Node::Facts::Puppetdb
  desc 'Publish facts to mqtt and save to PuppetDB.
       It uses PuppetDB to retrieve facts for catalog compilation.'

  # Publish facts to MQTT broker
  def save(request)
    Puppet.info 'Publish facts to mqtt'
    mqtt_config_file = Puppet[:confdir] + '/pe_mqtt.yaml'

    mqtt_config = YAML.load_file(mqtt_config_file)

    if mqtt_config['facts']['disabled']
      Puppet.info 'mqtt facts terminus is disabled, no fact data published to mqtt'
    else
      request_body = {
        'certname' => request.key,
        'facts' => request.instance.values,
        'name' => request.instance.name
      }

      begin
        Puppet.info 'Connecting to MQTT'
        mqtt_conn = MQTT::Client.connect(host: mqtt_config['mqtt']['hostname'], port: mqtt_config['mqtt']['port'])
        mqtt_conn.publish('puppet/facts', request_body)
      rescue => e
        Puppet.err 'Error in mqtt facts terminus.  Message: ' + e.message
      ensure
        Puppet.info 'Disconnect from MQTT'
        mqtt_conn.disconnect
      end
    end

    super(request)
  end
end
