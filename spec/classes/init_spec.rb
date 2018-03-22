require 'spec_helper'

describe 'monero' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) { facts }

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

        monerod_config_file_fixture = File.read(fixtures('monerod.conf'))
        it do
          is_expected.to contain_file('monerod_config_file').with_content(monerod_config_file_fixture)
                                                            .with('ensure' => 'file',
                                                                  'path'   => '/etc/monero/monerod.conf',
                                                                  'owner'  => 'monero',
                                                                  'group'  => 'monero',
                                                                  'mode'   => '0644')
        end

        monerod_service_fixture = File.read(fixtures('monerod.service'))
        it { is_expected.to contain_systemd__unit_file('monerod.service').with_content(monerod_service_fixture) }

        it do
          is_expected.to contain_service('monerod').with('ensure'     => 'running',
                                                         'enable'     => true,
                                                         'name'       => 'monerod',
                                                         'hasrestart' => true,
                                                         'subscribe'  => 'File[monerod_config_file]')
        end

        wallet_rpc_config_fixture = File.read(fixtures('monero-wallet-rpc.conf'))
        it do
          is_expected.to contain_file('wallet_rpc_config_file').with_content(wallet_rpc_config_fixture)
                                                               .with('ensure' => 'file',
                                                                     'path'   => '/etc/monero/monero-wallet-rpc.conf',
                                                                     'owner'  => 'monero',
                                                                     'group'  => 'monero',
                                                                     'mode'   => '0644')
        end

        wallet_rpc_service_fixture = File.read(fixtures('monero-wallet-rpc.service'))
        it { is_expected.to contain_systemd__unit_file('monero-wallet-rpc.service').with_content(wallet_rpc_service_fixture) }

        it do
          is_expected.to contain_service('wallet_rpc').with('ensure'     => 'running',
                                                            'enable'     => true,
                                                            'name'       => 'monero-wallet-rpc',
                                                            'hasrestart' => true,
                                                            'subscribe'  => 'File[wallet_rpc_config_file]')
        end

        describe 'parameter functionality' do
          context 'when service_enable is set to valid bool <false>' do
            let(:params) { { service_enable: false } }

            it { is_expected.to contain_service('monerod').with_enable(false) }
            it { is_expected.to contain_service('wallet_rpc').with_enable(false) }
          end

          context 'when service_ensure is set to valid string <stopped>' do
            let(:params) { { service_ensure: 'stopped' } }

            it { is_expected.to contain_service('monerod').with_ensure('stopped') }
            it { is_expected.to contain_service('wallet_rpc').with_ensure('stopped') }
          end

          context 'when service_manage is set to valid bool <false>' do
            let(:params) { { service_manage: false } }

            it { is_expected.not_to contain_service('monerod') }
            it { is_expected.not_to contain_service('wallet_rpc') }
            it { is_expected.not_to contain_systemd__unit_file('monerod.service') }
            it { is_expected.not_to contain_systemd__unit_file('monero-wallet-rpc.service') }
          end

          context 'when monerod_service_name is set to valid string <monerod3>' do
            let(:params) { { monerod_service_name: 'monerod3' } }

            it { is_expected.to contain_service('monerod').with_name('monerod3') }
          end

          context 'when wallet_rpc_service_name is set to valid string <monero-wallet-rpc3>' do
            let(:params) { { wallet_rpc_service_name: 'monero-wallet-rpc3' } }

            it { is_expected.to contain_service('wallet_rpc').with_name('monero-wallet-rpc3') }
          end

          context 'when monerod_config_file is set to valid string <monerod3.conf>' do
            let(:params) { { monerod_config_file: 'monerod3.conf' } }

            it { is_expected.to contain_file('monerod_config_file').with_path('/etc/monero/monerod3.conf') }
          end

          context 'when wallet_rpc_config_file is set to valid string <monero-wallet-rpc3.conf>' do
            let(:params) { { wallet_rpc_config_file: 'monero-wallet-rpc3.conf' } }

            it { is_expected.to contain_file('wallet_rpc_config_file').with_path('/etc/monero/monero-wallet-rpc3.conf') }
          end

          context 'when config_dir is set to valid path </etc/monero3>' do
            let(:params) { { config_dir: '/etc/monero3' } }

            it { is_expected.to contain_file('monero_config_dir').with_path('/etc/monero3') }
          end
        end
      end
    end
  end

  describe 'failures' do
    let(:facts) do
      {
        osfamily:               'Debian',
        operatingsystem:        'Debian',
        operatingsystemrelease: '8.0',
        path:                   '/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games',
        os: {
          family: 'Debian',
        },
      }
    end

    context 'when major release of Debian is unsupported' do
      let :facts do
        { osfamily:                  'Debian',
          operatingsystem:           'Debian',
          operatingsystemrelease:    '4.0' }
      end

      it 'fails' do
        expect {
          is_expected.to contain_class('monero')
        }.to raise_error(Puppet::Error, %r{monero supports Debian 8 \(jessie\)\. Detected operatingsystemrelease is <4\.0>\.})
      end
    end

    context 'when major release of Ubuntu is unsupported' do
      let :facts do
        { osfamily:                  'Debian',
          operatingsystem:           'Ubuntu',
          operatingsystemrelease:    '8.0' }
      end

      it 'fails' do
        expect {
          is_expected.to contain_class('monero')
        }.to raise_error(Puppet::Error, %r{monero supports Ubuntu 16\.04 \(xenial\)\. Detected operatingsystemrelease is <8\.0>\.})
      end
    end

    context 'when operatingsystem is unsupported' do
      let :facts do
        { osfamily:        'Debian',
          operatingsystem: 'Unsupported' }
      end

      it 'fails' do
        expect {
          is_expected.to contain_class('monero')
        }.to raise_error(Puppet::Error, %r{monero supports Debian and Ubuntu\. Detected operatingsystem is <Unsupported>\.})
      end
    end

    context 'when osfamily is unsupported' do
      let :facts do
        { osfamily: 'Unsupported' }
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
        operatingsystem:           'Debian',
        operatingsystemrelease:    '8.0',
        lsbdistcodename:           'jessie',
        path:                      '/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games',
        os: {
          family: 'Debian',
        },
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
        name: %w[log_level],
        valid: [242, '242'],
        invalid: [2.42, 'invalid', %w[array], { 'ha' => 'sh ' }, true, false, nil],
        message: 'Expected.*to be an Integer',
      },
      'string' => {
        name: %w[group monerod_config_file monerod_log_file monerod_service_name user wallet_rpc_config_file wallet_rpc_log_file wallet_rpc_service_name],
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
