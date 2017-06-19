require 'spec_helper'

describe 'upstart::validate_sys_limit' do
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
    it 'rejects invalid limit type' do
      is_expected.to run.with_params(['oops', '4', '5']).and_raise_error(
        /Invalid \$upstart::job::sys_limit\[LIMIT\] 'oops'/)
    end

    it 'rejects invalid SOFT limit' do
      is_expected.to run.with_params(['core', '40.5', '5']).and_raise_error(
        /Invalid \$upstart::job::sys_limit\[SOFT\] '40.5'/)
    end

    it 'rejects invalid HARD limit' do
      is_expected.to run.with_params(['core', '4', '5.05']).and_raise_error(
        /Invalid \$upstart::job::sys_limit\[HARD\] '5.05'/)
    end
  end
end
