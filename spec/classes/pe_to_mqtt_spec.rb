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
    end
  end
end
