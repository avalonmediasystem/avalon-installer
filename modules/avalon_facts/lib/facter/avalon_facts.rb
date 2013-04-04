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
    "rtmp://#{Facter.value("avalon_public_address")}:5080"
  end
end

Facter.add("tomcat_public_url") do
  setcode do
    "http://#{Facter.value("avalon_public_address")}:8983"
  end
end

