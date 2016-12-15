require 'spec_helper'

describe 'validate_sys_limit' do
  context 'valid sys limit specs' do
    ['core', 'cpu', 'data', 'fsize', 'memlock', 'msgqueue', 'nice', 'nofile',
      'nproc', 'rss', 'rtprio', 'sigpending', 'stack' ].each do |limit|
      it "validates with limit type '#{limit}'" do
        is_expected.to run.with_params([limit, '40', '50'])
      end
    end

    it "validates with unlimited" do
      is_expected.to run.with_params(['core', 'unlimited', 'unlimited'])
    end
  end

  context 'invalid sys limit specs' do
    it 'rejects an array smaller than 3' do
      is_expected.to run.with_params(['core', '4']).and_raise_error(Puppet::ParseError,
        /sys_limit must be an array with \[ 'LIMIT', 'SOFT', 'HARD' \]/)
    end

    it 'rejects an array larger than 3' do
      is_expected.to run.with_params(['core', '4', '5', '6']).and_raise_error(Puppet::ParseError,
        /sys_limit must be an array with \[ 'LIMIT', 'SOFT', 'HARD' \]/)
    end

    it 'rejects invalid limit type' do
      is_expected.to run.with_params(['oops', '4', '5']).and_raise_error(Puppet::ParseError,
        /sys_limit\[LIMIT\] must be one of: /)
    end

    it 'rejects invalid SOFT limit' do
      is_expected.to run.with_params(['core', '40.5', '5']).and_raise_error(Puppet::ParseError,
        /sys_limit\[SOFT\] must be one of: /)
    end

    it 'rejects invalid HARD limit' do
      is_expected.to run.with_params(['core', '4', '5.05']).and_raise_error(Puppet::ParseError,
        /sys_limit\[HARD\] must be one of: /)
    end
  end
end
