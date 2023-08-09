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
    mqtt_config_file = Puppet[:confdir] + '/pe_mqtt.yaml'

    mqtt_config = YAML.load_file(mqtt_config_file)

    if mqtt_config['facts']['disabled']
      Puppet.info 'MQTT facts terminus is disabled, no fact data published to MQTT broker'
    else
      facts = if mqtt_config['facts'].key?('selected_facts')
                request.instance.values.select { |k, _v| mqtt_config['facts']['selected_facts'].include?(k) }
              else
                request.instance.values
              end

      request_body = {
        'certname' => request.key,
        'name'     => request.instance.name,
        'facts'    => facts
      }

      begin
        Puppet.info 'Connecting to MQTT Broker: ' + mqtt_config['mqtt']['hostname']
        mqtt_conn = MQTT::Client.connect(host: mqtt_config['mqtt']['hostname'], port: mqtt_config['mqtt']['port'])
        Puppet.info 'Publish facts to MQTT Broker. Topic: ' + mqtt_config['facts']['topic']
        mqtt_conn.publish(mqtt_config['facts']['topic'], request_body)
      rescue => e
        Puppet.err 'Error in MQTT facts terminus.  Message: ' + e.message
      ensure
        unless mqtt_conn.nil?
          Puppet.info 'Disconnect from MQTT: ' + mqtt_config['mqtt']['hostname']
          mqtt_conn.disconnect
        end
      end
    end

    super(request)
  end
end
