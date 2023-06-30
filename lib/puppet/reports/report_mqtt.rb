require 'puppet'
require 'mqtt'
require 'yaml'

Puppet::Reports.register_report(:report_mqtt) do
  desc 'Publish reports to MQTT for use with other systems'

  # Define and configure the report processor.
  # rubocop:disable Style/RedundantSelf
  def process
    mqtt_config_file = Puppet[:confdir] + '/pe_mqtt.yaml'

    mqtt_config = YAML.load_file(mqtt_config_file)

    if mqtt_config['report']['disabled']
      Puppet.info 'report_mqtt is disabled, no report data published to mqtt'
    else
      begin
        Puppet.info 'Connecting to MQTT Broker: ' + mqtt_config['mqtt']['hostname']
        mqtt_conn = MQTT::Client.connect(host: mqtt_config['mqtt']['hostname'], port: mqtt_config['mqtt']['port'])

        if mqtt_config['report']['publish_status'] == 'all' || self.status == mqtt_config['report']['publish_status']
          Puppet.info 'Publish facts to MQTT Broker. Topic: ' + mqtt_config['report']['topic']
          mqtt_conn.publish(mqtt_config['report']['topic'], self.to_json)
        end
      rescue => e
        Puppet.err 'Error in report_mqtt report processor.  Message: ' + e.message
      ensure
        Puppet.info 'Disconnect from MQTT: ' + mqtt_config['mqtt']['hostname']
        mqtt_conn.disconnect
      end
    end
  end
end
