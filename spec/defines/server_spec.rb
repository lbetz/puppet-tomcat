require 'spec_helper'

describe('tomcat::server', :type => :define) do
  let(:title) { 'foobaz' }
  let(:pre_condition) { [
    "class { 'tomcat': ensure => stopped, enable => false }"
  ] }

  context 'with user => foo, group => foobar' do
    let(:facts) { {:osfamily => 'RedHat', :concat_basedir => '/tmp'} }
    let(:params) { {:user => 'foo', :group => 'foobar'} }
    it do
      should contain_file('/var/tomcat/foobaz').with({
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'foobar',
        'mode'   => '0775',
      })
      should contain_file('/var/tomcat/foobaz/bin').with({
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755',
      })
      should contain_file('/var/tomcat/foobaz/lib').with({
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0755',
      })
      should contain_file('/var/tomcat/foobaz/conf').with({
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'foobar',
        'mode'   => '0775',
      })
      should contain_file('/var/tomcat/foobaz/webapps').with({
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'foobar',
        'mode'   => '0775',
      })
      should contain_file('/var/tomcat/foobaz/work').with({
        'ensure' => 'directory',
        'owner'  => 'root',
        'group'  => 'foobar',
        'mode'   => '0775',
      })
      should contain_file('/var/tomcat/foobaz/logs').with({
        'ensure' => 'directory',
        'owner'  => 'foo',
        'group'  => 'root',
        'mode'   => '0755',
      })
      should contain_file('/var/tomcat/foobaz/temp').with({
        'ensure' => 'directory',
        'owner'  => 'foo',
        'group'  => 'root',
        'mode'   => '0755',
      })
      should contain_file('/var/tomcat/foobaz/conf/web.xml').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'foobar',
        'mode'   => '0664',
      })
    end
  end

end
