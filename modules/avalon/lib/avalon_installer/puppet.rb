module AvalonInstaller::Puppet
  def self.pwcrypt(input=nil, type='1')
    if input.nil? or input.empty?
      raise ArgumentError.new("pwcrypt requires a string to encrypt")
    else
      salt = rand(36**8).to_s(36)
      hash = input.crypt("$#{type}$#{salt}$")
      return hash
    end
  end
end

