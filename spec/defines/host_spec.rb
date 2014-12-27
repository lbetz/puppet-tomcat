require 'spec_helper'

describe('tomcat::host', :type => :define) do
  let(:title) { 'myapp:myService:myEngine:myHost' }
  let(:facts) { {:osfamily => 'RedHat', :concat_basedir => '/tmp'} }
  let(:pre_condition) { [
    "class { 'tomcat': }"
  ] }

  context 'with server => myapp, service => myService, engine => myEngine, host => myHost' do
    let(:params) { {:app_base => 'webapps', :auto_deploy => 'true', :unpack_wars => 'true', :xml_validation => 'false', :xml_namespace_aware => 'false'} }
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myEngine:myHost-header') \
        .with({ 'order' => '50_myService_50_myHost_00' }) \
        .with_content(/^\s*<Host name=\"myHost\"  appBase=\"webapps\"\n\s*unpackWARs=\"true\" autoDeploy=\"true\"\n\s*xmlValidation=\"false\" xmlNamespaceAware=\"false\">/)
      should contain_concat__fragment('server.xml-myapp:myService:myEngine:myHost-footer') \
        .with({ 'order' => '50_myService_50_myHost_99' }) \
        .with_content(/^\s*<\/Host>/)
    end
  end

  context 'with app_base => foo' do
    let(:params) { {:app_base => 'foo'} }
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myEngine:myHost-header') \
        .with_content(/^\s*<Host name=\"myHost\"  appBase=\"foo\"/)
    end
  end

  context 'with auto_deploy => false' do
    let(:params) { {:auto_deploy => 'false'} }
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myEngine:myHost-header') \
        .with_content(/autoDeploy=\"false\"/)
    end
  end

  context 'with unpack_wars => false' do
    let(:params) { {:unpack_wars => 'false'} }
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myEngine:myHost-header') \
        .with_content(/unpackWARs=\"false\"/)
    end
  end

  context 'with xml_validation => true' do
    let(:params) { {:xml_validation => 'true'} }
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myEngine:myHost-header') \
        .with_content(/xmlValidation=\"true\"/)
    end
  end

  context 'with xml_namespace_aware => true' do
    let(:params) { {:xml_namespace_aware => 'true'} }
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myEngine:myHost-header') \
        .with_content(/xmlNamespaceAware=\"true\"/)
    end
  end

end
