require 'spec_helper'

describe('tomcat::listener', :type => :define) do
  let(:title) { 'myapp:foo' }
  let(:facts) { {:osfamily => 'RedHat', :concat_basedir => '/tmp'} }
  let(:pre_condition) { [
    "class { 'tomcat': }"
  ] }

  context 'with server => myapp, class_name => foo' do
    let(:params) { {:server => 'myapp', :class_name => 'foo'} }
    it do
      should contain_concat__fragment('myapp:foo') \
        .with({ 'order' => '20' }) \
        .with_content(/^\s*<Listener className='foo'\/>/)
    end
  end

  context 'with server => myapp, class_name => foo, ssl_engine => on' do
    let(:params) { {:server => 'myapp', :class_name => 'foo', :ssl_engine => 'on'} }
    it do
      should contain_concat__fragment('myapp:foo') \
        .with({ 'order' => '20' }) \
        .with_content(/^\s*<Listener className='foo' SSLEngine='on'\/>/)
    end
  end

end
