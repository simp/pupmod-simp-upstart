# Validate the initial system resource limits for a job's processes
#
# See init(5) for more information.
Puppet::Functions.create_function(:'upstart::validate_sys_limit') do

  # @param sys_limit
  #   3-tuple containing the limit name, soft limit, and hard limit
  #
  # @return true in validation succeeds
  # @raise upon any validation failure
   dispatch :validate_sys_limit do
     required_param 'Optional[Array[String, 3, 3]]', :sys_limit
   end


  def validate_sys_limit(sys_limit)
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
      if not t_valid_limits.include?(sys_limit[0]) then
        fail("Error: Invalid $upstart::job::sys_limit[LIMIT] '#{sys_limit[0]}'. Must be one of: '#{t_valid_limits.join("', '")}'."
        )
      end
      if not sys_limit[1] =~ /^((\d+)|unlimited)$/ then
        raise Puppet::ParseError.new(
          "Error: Invalid $upstart::job::sys_limit[SOFT] '#{sys_limit[1]}'. Must be one of: '<INTEGER>' or 'unlimited'."
        )
      end
      if not sys_limit[2] =~ /^((\d+)|unlimited)$/ then
        raise Puppet::ParseError.new(
          "Error: Invalid $upstart::job::sys_limit[HARD] '#{sys_limit[2]}'. Must be one of: '<INTEGER>' or 'unlimited'."
        )
      end
    end

  end
end
