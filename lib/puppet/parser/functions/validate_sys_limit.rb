module Puppet::Parser::Functions
  newfunction(:validate_sys_limit) do |args|

    sys_limit = args[0]

    t_valid_limits = [
      'core',
      'cpu',
      'data',
      'fsize',
      'memlock',
      'msgqueue',
      'nice',
      'nofile',
      'nproc',
      'rss',
      'rtprio',
      'sigpending',
      'stack'
    ]

    if not sys_limit.eql?('nil') then
      if not Array(sys_limit).size == 3 then
        raise Puppet::ParseError.new(
          "Error: $upstart::job::sys_limit must be an array with [ 'LIMIT', 'SOFT', 'HARD' ] per init(5)."
        )
      end
      if not t_valid_limits.include?(sys_limit[0]) then
        raise Puppet::ParseError.new(
          "Error: $upstart::job::sys_limit[LIMIT] must be one of: '#{t_valid_limits.join("', '")}'."
        )
      end
      if not sys_limit[1] =~ /^((\d+)|unlimited)$/ then
        raise Puppet::ParseError.new(
          "Error: $upstart::job::sys_limit[SOFT] must be one of: '<INTEGER>' or 'unlimited'."
        )
      end
      if not sys_limit[2] =~ /^((\d+)|unlimited)$/ then
        raise Puppet::ParseError.new(
          "Error: $upstart::job::sys_limit[HARD] must be one of: '<INTEGER>' or 'unlimited'."
        )
      end
    end

  end
end
