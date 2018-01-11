require 'spec_helper'
describe 'monero' do
  platforms = {
    'debian8' =>
      { osfamily:        'Debian',
        release:         '8.0',
        majrelease:      '8',
        lsbdistcodename: 'jessie' },
    'ubuntu1604' =>
      { osfamily:        'Debian',
        release:         '16.04',
        majrelease:      '16',
        lsbdistcodename: 'xenial' },
  }

  describe 'with default values for parameters on' do
    platforms.sort.each do |k, v|
      context k.to_s do
        let :facts do
          { lsbdistcodename:           v[:lsbdistcodename],
            osfamily:                  v[:osfamily],
            kernelrelease:             v[:release], # Solaris specific
            operatingsystemrelease:    v[:release], # Linux specific
            operatingsystemmajrelease: v[:majrelease] }
        end

        it { is_expected.to compile.with_all_deps }

        it { is_expected.to contain_class('monero') }

        it do
          is_expected.to contain_group('monero').with('ensure' => 'present',
                                                      'system' => true)
        end

        it do
          is_expected.to contain_user('monero').with('ensure'  => 'present',
                                                     'comment' => 'Monero Daemon',
                                                     'gid'     => 'monero',
                                                     'home'    => '/var/lib/monero',
                                                     'shell'   => '/bin/false',
                                                     'system'  => true)
        end

        it do
          is_expected.to contain_file('/run/monero').with('ensure' => 'directory',
                                                          'owner'  => 'monero',
                                                          'group'  => 'monero',
                                                          'mode'   => '0755')
        end

        it do
          is_expected.to contain_file('/var/log/monero').with('ensure' => 'directory',
                                                              'owner'  => 'monero',
                                                              'group'  => 'monero',
                                                              'mode'   => '0755')
        end

        it do
          is_expected.to contain_file('monero_data_dir').with('ensure' => 'directory',
                                                              'path'   => '/var/lib/monero',
                                                              'owner'  => 'monero',
                                                              'group'  => 'monero',
                                                              'mode'   => '0755')
        end

        it do
          is_expected.to contain_file('monero_config').with('ensure' => 'file',
                                                            'path'   => '/etc/monerod.conf',
                                                            'owner'  => 'monero',
                                                            'group'  => 'monero',
                                                            'mode'   => '0644',
                                                            'notify' => 'Service[monerod]')
        end

        monero_config_fixture = File.read(fixtures("monerod.conf.#{k}"))
        it { is_expected.to contain_file('monero_config').with_content(monero_config_fixture) }

        it do
          is_expected.to contain_file('/lib/systemd/system/monerod.service').with('ensure' => 'file',
                                                                                  'owner'  => 'root',
                                                                                  'group'  => 'root',
                                                                                  'mode'   => '0644')
        end

        monero_service_fixture = File.read(fixtures("monerod.service.#{k}"))
        it { is_expected.to contain_file('/lib/systemd/system/monerod.service').with_content(monero_service_fixture) }

        it do
          is_expected.to contain_service('monerod').with('ensure'     => 'running',
                                                         'enable'     => true,
                                                         'name'       => 'monerod',
                                                         'hasrestart' => true,
                                                         'subscribe'  => 'File[monero_config]')
        end
      end
    end
  end

  describe 'parameter functionality' do
    let(:facts) do
      {
        osfamily:        'Debian',
        lsbdistcodename: 'jessie',
      }
    end

    context 'when service_enable is set to valid bool <false>' do
      let(:params) { { service_enable: false } }

      it { is_expected.to contain_service('monero').with_enable(false) }
    end

    context 'when service_ensure is set to valid string <stopped>' do
      let(:params) { { service_ensure: 'stopped' } }

      it { is_expected.to contain_service('monero').with_ensure('stopped') }
    end

    context 'when service_manage is set to valid bool <false>' do
      let(:params) { { service_manage: false } }

      it { is_expected.not_to contain_service('monero') }
      it { is_expected.not_to contain_file('/lib/systemd/system/monero.service') }
    end

    context 'when service_name is set to valid string <stopped>' do
      let(:params) { { service_name: 'monero3' } }

      it { is_expected.to contain_service('monero').with_name('monero3') }
    end

    context 'when log_file is set to valid string <monero3.log>' do
      let(:params) { { logfile: 'monero3.log' } }

      it { is_expected.to contain_file('monero_config').with_content(%r{^set logfile /var/log/monero/monero3.log$}) }
    end

    context 'when config_file is set to valid string <monero3.conf>' do
      let(:params) { { config_file: 'monero3.conf' } }

      it { is_expected.to contain_file('monero_config').with_path('/etc/monero3.conf') }
    end

    context 'when config_dir is set to valid path </etc/monero>' do
      let(:params) { { config_dir: '/etc/monero' } }

      it { is_expected.to contain_file('monero_config_dir').with_path('/etc/monero') }
    end
  end

  describe 'failures' do
    let(:facts) do
      {
        osfamily:        'Debian',
        lsbdistcodename: 'jessie',
      }
    end

    context 'when major release of Debian is unsupported' do
      let :facts do
        { osfamily:                  'Debian',
          operatingsystemmajrelease: '4',
          lsbdistcodename:           'etch' }
      end

      it 'fails' do
        expect {
          is_expected.to contain_class('monero')
        }.to raise_error(Puppet::Error, %r{monero supports Debian 8 \(jessie\) and Ubuntu 16.04 \(xenial\). Detected lsbdistcodename is <etch>\.})
      end
    end

    context 'when major release of Ubuntu is unsupported' do
      let :facts do
        { osfamily:                  'Debian',
          operatingsystemmajrelease: '8',
          lsbdistcodename:           'hardy' }
      end

      it 'fails' do
        expect {
          is_expected.to contain_class('monero')
        }.to raise_error(Puppet::Error, %r{monero supports Debian 8 \(jessie\) and Ubuntu 16.04 \(xenial\). Detected lsbdistcodename is <etch>\.})
      end
    end

    context 'when osfamily is unsupported' do
      let :facts do
        { osfamily:                  'Unsupported',
          operatingsystemmajrelease: '9' }
      end

      it 'fails' do
        expect {
          is_expected.to contain_class('monero')
        }.to raise_error(Puppet::Error, %r{monero supports osfamilies Debian\. Detected osfamily is <Unsupported>\.})
      end
    end
  end

  describe 'variable type and content validations' do
    # set needed custom facts and variables
    let(:facts) do
      {
        osfamily:                  'Debian',
        operatingsystemrelease:    '8.0',
        operatingsystemmajrelease: '8',
        lsbdistcodename:           'jessie',
      }
    end
    let(:validation_params) do
      {
        #:param => 'value',
      }
    end

    validations = {
      'absolute_path' => {
        name: %w[config_dir data_dir log_dir],
        valid: %w[/absolute/filepath /absolute/directory/],
        invalid: ['invalid', 3, 2.42, %w[array], { 'ha' => 'sh' }],
        message: 'is not an absolute path',
      },
      'bool_stringified' => {
        name: %w[service_enable service_manage],
        valid: [true, 'true', false, 'false'],
        invalid: ['invalid', 3, 2.42, %w[array], { 'ha' => 'sh' }, nil],
        message: '(is not a boolean|Unknown type of boolean)',
      },
      'integer_stringified' => {
        name: %w[lo_level],
        valid: [242, '242'],
        invalid: [2.42, 'invalid', %w[array], { 'ha' => 'sh ' }, true, false, nil],
        message: 'Expected.*to be an Integer',
      },
      'string' => {
        name: %w[config_file group log_file service_name user],
        valid: ['present'],
        invalid: [%w[array], { 'ha' => 'sh' }],
        message: 'is not a string',
      },
      'service_ensure_string' => {
        name: %w[service_ensure],
        valid: ['running'],
        invalid: [%w[array], { 'ha' => 'sh' }],
        message: 'is not a string',
      },
    }

    validations.sort.each do |type, var|
      var[:name].each do |var_name|
        var[:valid].each do |valid|
          context "with #{var_name} (#{type}) set to valid #{valid} (as #{valid.class})" do
            let(:params) { validation_params.merge(:"#{var_name}" => valid) }

            it { is_expected.to compile }
          end
        end

        var[:invalid].each do |invalid|
          context "with #{var_name} (#{type}) set to invalid #{invalid} (as #{invalid.class})" do
            let(:params) { validation_params.merge(:"#{var_name}" => invalid) }

            it 'fails' do
              expect {
                catalogue
              }.to raise_error(Puppet::Error, %r{#{var[:message]}})
            end
          end
        end
      end # var[:name].each
    end # validations.sort.each
  end # describe 'variable type and content validations'
end
