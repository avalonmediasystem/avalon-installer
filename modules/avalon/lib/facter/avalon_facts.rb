Facter.add("avalon_public_address") do
  setcode do
    Facter::Util::Resolution.exec('hostname -f')
  end
end

Facter.add("avalon_public_url") do
  setcode do
    "http://#{Facter.value("avalon_public_address")}"
  end
end

Facter.add("matterhorn_public_url") do
  setcode do
    "http://#{Facter.value("avalon_public_address")}:18080"
  end
end

Facter.add("red5_public_url") do
  setcode do
    "rtmp://#{Facter.value("avalon_public_address")}"
  end
end

Facter.add("tomcat_public_url") do
  setcode do
    "http://#{Facter.value("avalon_public_address")}:8983"
  end
end

Facter.add("avalon_dropbox_user") do
  setcode do 
    "avalondrop"
  end
end

Facter.add("avalon_dropbox_password") do
  setcode do 
    nil
  end
end

Facter.add("avalon_dropbox_password_hash") do
  algorithms = { 'md5' => '1', 'sha256' => '5', 'sha512' => '6' }
  setcode do
    new_pw = Facter.value("avalon_dropbox_password")
    if new_pw.nil?
      lines = File.read('/etc/shadow').split(/\n/).collect { |l| l.split(/:/) }
      avalon_user = Array(lines.find { |p| p.first == Facter.value("avalon_dropbox_user") and not (p[1].nil? or p[1].empty?) })
      avalon_user[1]
    else
      alg = '1'
      begin
        config = File.read('/etc/login.defs')
        entry  = config.lines.find { |l| l =~ /^ENCRYPT_METHOD\s+(\w+)/ }
        alg = algorithms[$1.downcase]
      rescue
      end
      salt = rand(36**8).to_s(36)
      new_pw.crypt("$#{alg}$#{salt}$")
    end
  end
end

Facter.add("avalon_admin_user") do
  setcode do
    "archivist1@example.com"
  end
end

Facter.add("rails_env") do
  setcode do
    "production"
  end
end