require 'spec_helper'

describe('tomcat::realm', :type => :define) do
  let(:title) { 'myapp:myService:myEngine:myHost:myRealm' }
  let(:facts) { {:osfamily => 'RedHat', :concat_basedir => '/tmp'} }
  let(:pre_condition) { [
    "class { 'tomcat': }"
  ] }

  context 'with host => myHost, realm => myRealm, class_name => foo' do
    let(:title) { 'myapp:myService:myEngine:myHost:myRealm:foo' }
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myEngine:myHost:myRealm:foo') \
        .with({ 'order' => '50_myService_50_myHost_22_myRealm_50' }) \
        .with_content(/^\s*<Realm className=\'foo\' \/>/)
    end
  end

  context 'with host => myHost, realm => myRealm' do
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myEngine:myHost:myRealm') \
        .with({ 'order' => '50_myService_50_myHost_20' }) \
        .with_content(/^\s*<Realm className=\'myRealm\' \/>/)
    end
  end

  context 'realm => myRealm, class_name => foo' do
    let(:title) { 'myapp:myService:myEngine:*:myRealm:foo' }
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myEngine:*:myRealm:foo') \
        .with({ 'order' => '50_myService_42_myRealm_50' }) \
        .with_content(/^\s*<Realm className=\'foo\' \/>/)
    end
  end

  context 'with realm => myRealm' do
    let(:title) { 'myapp:myService:myEngine:*:myRealm' }
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myEngine:*:myRealm') \
        .with({ 'order' => '50_myService_40' }) \
        .with_content(/^\s*<Realm className=\'myRealm\' \/>/)
    end
  end

  context 'with host => myHost, realms => { foo => {} }' do
    let(:params) { {:realms => { 'foo' => {} }} }
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myEngine:myHost:myRealm-header') \
        .with({ 'order' => '50_myService_50_myHost_22_myRealm_00' }) \
        .with_content(/^\s*<Realm className=\'myRealm\'/)
      should contain_concat__fragment('server.xml-myapp:myService:myEngine:myHost:myRealm-footer') \
        .with({ 'order' => '50_myService_50_myHost_22_myRealm_99' }) \
        .with_content(/^\s*<\/Realm>/)
      should contain_concat__fragment('server.xml-myapp:myService:myEngine:myHost:myRealm:foo') \
        .with({ 'order' => '50_myService_50_myHost_22_myRealm_50' }) \
        .with_content(/^\s*<Realm className=\'foo\' \/>/)
    end
  end

  context 'with realms => { foo => {} }' do
    let(:title) { 'myapp:myService:myEngine:*:myRealm' }
    let(:params) { {:realms => { 'foo' => {} }} }
    it do
      should contain_concat__fragment('server.xml-myapp:myService:myEngine:*:myRealm-header') \
        .with({ 'order' => '50_myService_42_myRealm_00' }) \
        .with_content(/^\s*<Realm className=\'myRealm\'/)
      should contain_concat__fragment('server.xml-myapp:myService:myEngine:*:myRealm-footer') \
        .with({ 'order' => '50_myService_42_myRealm_99' }) \
        .with_content(/^\s*<\/Realm>/)
      should contain_concat__fragment('server.xml-myapp:myService:myEngine:*:myRealm:foo') \
        .with({ 'order' => '50_myService_42_myRealm_50' }) \
        .with_content(/^\s*<Realm className=\'foo\' \/>/)
    end
  end

end
