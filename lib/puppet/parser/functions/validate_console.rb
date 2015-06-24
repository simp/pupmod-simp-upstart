module Puppet::Parser::Functions
  newfunction(:validate_console) do |args|

    console = args[0]

    if not ( console.eql?('nil') or ['output','owner'].include?(console) ) then
      raise Puppet::ParseError.new(
        "Error: $upstart::console must be one of 'output' or 'owner'."
      )
    end
    
  end
end
