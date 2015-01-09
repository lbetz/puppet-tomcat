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

end

# Tomcat7 on RedHat
describe('tomcat', :type => :class) do
  let(:facts) { {:osfamily => 'RedHat', :concat_basedir => '/tmp'} }
  let(:params) { {:version => '7'} }

  context 'on redhat with version => 7' do
    it do
      should contain_package('tomcat').with({
        'ensure' => 'installed',
      })
    end
  end

end

# Tomcat6 on RedHat
describe('tomcat', :type => :class) do
  let(:facts) { {:osfamily => 'RedHat', :concat_basedir => '/tmp'} }
  let(:params) { {:version => '6'} }

  context 'on redhat with version => 6' do
    it do
      should contain_package('tomcat6').with({
        'ensure' => 'installed',
      })
    end
  end

end

# Tomcat6 on Debian
describe('tomcat', :type => :class) do
  let(:facts) { {:osfamily => 'Debian', :concat_basedir => '/tmp'} }
  let(:params) { {:version => '6'} }

  context 'on debian with version => 6' do
    it do
      should contain_package('tomcat6').with({
        'ensure' => 'installed',
      })
    end
  end

end

# Tomcat7 on Debian
describe('tomcat', :type => :class) do
  let(:facts) { {:osfamily => 'Debian', :concat_basedir => '/tmp'} }
  let(:params) { {:version => '7'} }

  context 'on debian with version => 7' do
    let(:facts) { {:osfamily => 'Debian', :concat_basedir => '/tmp'} }
    it do
      should contain_package('tomcat7').with({
        'ensure' => 'installed',
      })
    end
  end

end
