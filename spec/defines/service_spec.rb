require 'spec_helper'

describe('tomcat::service', :type => :define) do
  let(:title) { 'myapp:myService' }
  let(:facts) { {:osfamily => 'RedHat', :concat_basedir => '/tmp'} }
  let(:pre_condition) { [
    "class { 'tomcat': }"
  ] }

  context 'with server => myapp, service => myService' do
    let(:params) { {:connectors => {}, :engine => {}} }
    it do
      should contain_concat__fragment('server.xml-myapp:myService-header') \
        .with({ 'order' => '50_myService_00' }) \
        .with_content(/^\s*<Service name='myService'>/)
      should contain_concat__fragment('server.xml-myapp:myService-footer') \
        .with({ 'order' => '50_myService_99' }) \
        .with_content(/^\s*<\/Service>/)
    end
  end

  context 'with engine => foo (non valid value)' do
    let(:params) { {:connectors => {}, :engine => 'foo'} }
    it do
      expect {
        should contain_concat__fragment('server.xml-myapp:myService-header')
      }.to raise_error(Puppet::Error, /is not a Hash/)
    end
  end

  context 'with connectors => foo (non valid value)' do
    let(:params) { {:connectors => 'foo', :engine => {}} }
    it do
      expect {
        should contain_concat__fragment('server.xml-myapp:myService-header')
      }.to raise_error(Puppet::Error, /is not a Hash/)
    end
  end

end
