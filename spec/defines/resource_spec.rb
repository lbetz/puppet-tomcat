require 'spec_helper'

describe('tomcat::resource', :type => :define) do
  let(:title) { 'myapp:myResource' }
  let(:facts) { {:osfamily => 'RedHat', :concat_basedir => '/tmp'} }
  let(:pre_condition) { [
    "class { 'tomcat': }"
  ] }

  context 'with type => foo, auth => bar' do
    let(:params) { {:type => 'foo', :auth => 'bar'} }
    it do
      should contain_concat__fragment('server.xml-myapp:myResource') \
        .with({ 'order' => '35' }) \
        .with_content(/^\s*<Resource name=\"myResource\" auth=\"bar\"\n\s*type=\"foo\"\n\s*\/>/)
    end
  end

  context 'with type => foo, extra_attrs => { attr1 => bar, attr2 => baz }' do
    let(:params) { {:type => 'foo', :extra_attrs => {'attr1' => 'bar', 'attr2' => 'baz'}} }
    it do
      should contain_concat__fragment('server.xml-myapp:myResource') \
        .with({ 'order' => '35' }) \
        .with_content(/^\s*attr1=\"bar\"\n\s*attr2=\"baz\"\n\s*\/>/)
    end
  end

end
