require 'spec_helper'

describe('tomcat::connector', :type => :define) do
  let(:title) { 'myapp:myService:myConnector' }
  let(:facts) { {:osfamily => 'RedHat', :concat_basedir => '/tmp'} }
  let(:pre_condition) { [
    "class { 'tomcat': }"
  ] }

  context 'with defaults' do
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myConnector') \
        .with({ 'order' => '50_myService_10' }) \
        .with_content(/^\s*<Connector URIEncoding=\"UTF-8\"\n\s*port=\"8080\"\n\s*protocol=\"HTTP\/1\.1"\n\s*connectionTimeout=\"20000\"\n\s*redirectPort=\"8443\"/)
    end
  end

  context 'with uri_encoding => foo' do
    let(:params) { {:uri_encoding => 'foo'} }
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myConnector') \
        .with({ 'order' => '50_myService_10' }) \
        .with_content(/^\s*<Connector URIEncoding=\"foo\"/)
    end
  end

  context 'with port => 8081' do
    let(:params) { {:port => '8081'} }
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myConnector') \
        .with({ 'order' => '50_myService_10' }) \
        .with_content(/^\s*port=\"8081\"/)
    end
  end

  context 'with address => 127.0.0.1' do
    let(:params) { {:address => '127.0.0.1'} }
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myConnector') \
        .with({ 'order' => '50_myService_10' }) \
        .with_content(/^\s*address=\"127.0.0.1\"/)
    end
  end

  context 'with protocol => AJP/1.3' do
    let(:params) { {:protocol => 'AJP/1.3'} }
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myConnector') \
        .with({ 'order' => '50_myService_10' }) \
        .with_content(/^\s*protocol=\"AJP\/1.3\"/)
    end
  end

  context 'with connection_timeout => 3000' do
    let(:params) { {:connection_timeout => '3000'} }
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myConnector') \
        .with({ 'order' => '50_myService_10' }) \
        .with_content(/^\s*connectionTimeout=\"3000\"/)
    end
  end

  context 'with redirect_port => 8444' do
    let(:params) { {:redirect_port => '8444'} }
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myConnector') \
        .with({ 'order' => '50_myService_10' }) \
        .with_content(/^\s*redirectPort=\"8444\"/)
    end
  end

end
