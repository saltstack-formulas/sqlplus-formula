# frozen_string_literal: true

title 'sqlplus archives profile'

control 'sqlplus archive' do
  impact 1.0
  title 'should be installed'

  describe file('/etc/default/sqlplus.sh') do
    it { should exist }
  end
  # describe file('/usr/local/oracle/sqlplus-*/bin/sqlplus') do
  #   it { should exist }
  # end
  describe file('/usr/share/applications/sqlplus.desktop') do
    it { should exist }
  end
  describe file('/usr/local/bin/sqlplus') do
    it { should exist }
  end
end
