# frozen_string_literal: true

require 'spec_helper'

describe 'pe_to_mqtt' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:pre_condition) do
        <<-MANIFEST
        Service { 'pe-puppetserver':
        }
        MANIFEST
      end

      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('puppet_agent_mqtt') }
      it { is_expected.to contain_package('puppet_server_mqtt') }
      it { is_expected.to contain_file('/etc/puppetlabs/puppet/mqtt_routes.yaml') }
      it { is_expected.to contain_file('/etc/puppetlabs/puppet/pe_mqtt.yaml') }
      it { is_expected.to contain_ini_setting('change default route_file') }
      it { is_expected.to contain_ini_subsetting('enable report_mqtt') }
    end
  end
end
