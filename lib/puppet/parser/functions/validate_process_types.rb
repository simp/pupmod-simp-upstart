module Puppet::Parser::Functions
  newfunction(:validate_process_types) do |args|

    process_type = args[0]

    if not ( process_type.eql?('nil') or ['exec','script'].include?(process_type) ) then
      raise Puppet::ParseError.new(
        "Error: Process type must be one of 'exec' or 'script'. process_type is #{process_type}"
      )
    end

  end
end
