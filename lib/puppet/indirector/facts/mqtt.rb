require 'puppet/indirector/facts/puppetdb'
require 'mqtt'
require 'yaml'

# mqtt.rb
class Puppet::Node::Facts::Mqtt < Puppet::Node::Facts::Puppetdb
  desc 'Publish facts to mqtt and save to PuppetDB.
       It uses PuppetDB to retrieve facts for catalog compilation.'

  def save(request)
    Puppet.info 'Publish facts to mqtt'

    mqtt_config_file = Puppet[:confdir] + '/report_mqtt.yaml'

    mqtt_config = YAML.load_file(mqtt_config_file)

    request_body = {
      'certname' => request.key,
      'facts' => request.instance.values,
      'name' => request.instance.name
    }

    begin
      Puppet.info 'Connecting to MQTT'
      mqtt_conn = MQTT::Client.connect(host: mqtt_config['mqtt']['hostname'], port: mqtt_config['mqtt']['port'])

      if mqtt_config['publish_status'] == 'all' || status == mqtt_config['publish_status']
        mqtt_conn.publish('puppet/facts', request_body)
      end
    rescue => e
      Puppet.err 'Error in report_mqtt report processor.  Message: ' + e.message
    ensure
      Puppet.info 'Disconnect from MQTT'
      mqtt_conn.disconnect
    end

    super(request)
  end
end
