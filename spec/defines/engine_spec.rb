require 'spec_helper'

describe('tomcat::engine', :type => :define) do
  let(:title) { 'myapp:myService:myEngine' }
  let(:facts) { {:osfamily => 'RedHat', :concat_basedir => '/tmp'} }
  let(:pre_condition) { [
    "class { 'tomcat': }"
  ] }

  context 'with server => myapp, service => myService, engine => myEngine' do
    let(:params) { {:hosts => {}} }
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myEngine-header') \
        .with({ 'order' => '50_myService_20' }) \
        .with_content(/^\s*<Engine name='myEngine' defaultHost='localhost'>/)
      should contain_concat__fragment('server.xml-myapp:myService:myEngine-footer') \
        .with({ 'order' => '50_myService_89' }) \
        .with_content(/^\s*<\/Engine>/)
    end
  end

  context 'with hosts => foo (non valid value)' do
    let(:params) { {:hosts => 'foo'} }
    it do
      expect {
        should contain_concat__fragment('server.xml-myapp:myService:myEngine-header')
      }.to raise_error(Puppet::Error, /is not a Hash/)
    end
  end

  context 'with realms => foo (non valid value)' do
    let(:params) { {:hosts => {}, :realms => 'foo'} }
    it do
      expect {
        should contain_concat__fragment('server.xml-myapp:myService:myEngine-header')
      }.to raise_error(Puppet::Error, /is not a Hash/)
    end
  end

end
