require 'spec_helper'

describe('tomcat', :type => :class) do
  let(:facts) { {:osfamily => 'RedHat', :concat_basedir => '/tmp'} }

  context 'on unsupported os' do
    let(:facts) { {:osfamily => 'foo', :operatingsystem => 'foo'} }
    it do
      expect {
        should contain_concat('tomcat::params')
      }.to raise_error(Puppet::Error, /Your plattform is not support/)
    end
  end

  context 'with unsupported version' do
    let(:params) { {:version => 'foo'} }
    it do
      expect {
        should contain_concat('tomcat::params')
      }.to raise_error(Puppet::Error, /Supported versions are/)
    end
  end

  context 'on redhat with version => 6' do
    let(:params) { {:version => '6'} }
    it do
      should contain_package('tomcat6').with({
        'ensure' => 'installed',
      })
    end
  end

  context 'on redhat with version => 7' do
    let(:params) { {:version => '7'} }
    it do
      should contain_package('tomcat').with({
        'ensure' => 'installed',
      })
    end
  end

  context 'on debian with version => 6' do
    let(:facts) { {:osfamily => 'Debian', :concat_basedir => '/tmp'} }
    let(:params) { {:version => '6'} }
    it do
      should contain_package('tomcat6').with({
        'ensure' => 'installed',
      })
    end
  end

  context 'on debian with version => 7' do
    let(:facts) { {:osfamily => 'Debian', :concat_basedir => '/tmp'} }
    let(:params) { {:version => '7'} }
    it do
      should contain_package('tomcat7').with({
        'ensure' => 'installed',
      })
    end
  end

end
