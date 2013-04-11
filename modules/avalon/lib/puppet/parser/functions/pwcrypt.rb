module Puppet::Parser::Functions
  newfunction(:pwcrypt, :type => :rvalue) do |args|
    input = args[0]
    if input.nil? or input.empty?
      raise Puppet::ParseError.new("pwcrypt requires a string to encrypt")
    else
      type     = args[1] || 1
      salt_len = args[2] || 8
      salt     = rand(36**salt_len).to_s(36)
      hash     = input.crypt("$#{type}$#{salt}$")
      return hash
    end
  end
end