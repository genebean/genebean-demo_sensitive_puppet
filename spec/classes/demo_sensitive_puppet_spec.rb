require 'spec_helper'

describe 'demo_sensitive_puppet' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      context 'with valid params' do
        let(:facts) { os_facts }
        let(:params) do
          {
            'password' => RSpec::Puppet::RawString.new("Sensitive('pa55w0rd')"),
          }
        end

        it { is_expected.to compile }
        it { is_expected.to contain_file('secrets_file').with_content('pa55w0rd') }
        case os_facts[:os]['family']
        when 'windows'
          it { is_expected.to contain_file('secrets_file').with_path('C:/secrets_file') }
        else
          it { is_expected.to contain_file('secrets_file').with_path('/tmp/secrets_file') }
        end
      end
      context 'with invalid params' do
        let(:facts) { os_facts }
        let(:params) do
          {
            'password' => 'pa55w0rd',
          }
        end

        it { is_expected.to compile.and_raise_error(%r{parameter 'password' expects a Sensitive}) }
      end
    end
  end
end
