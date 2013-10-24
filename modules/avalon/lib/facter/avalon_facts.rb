# Copyright 2011-2013, The Trustees of Indiana University and Northwestern
#   University.  Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
# 
# You may obtain a copy of the License at
# 
# http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software distributed 
#   under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
#   CONDITIONS OF ANY KIND, either express or implied. See the License for the 
#   specific language governing permissions and limitations under the License.
# ---  END LICENSE_HEADER BLOCK  ---

require 'etc'

Facter.add("avalon_public_address") do
  setcode do
    result = Facter::Util::Resolution.exec('hostname -f')
    confs = Dir['/etc/httpd/conf.d/*avalon*.conf']
    begin
      result = File.read(confs.first).split(/\n/).find { |l| l =~ /ServerName/ }.split.last
    rescue
    end
    result
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
    result = "avalondrop"
    begin
      result = Etc.getpwuid(File.stat('/var/avalon/dropbox').uid).name
    rescue
    end
    result
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
    result = "archivist1@example.com"
    env = Facter.value("rails_env")
    begin
      config = YAML.load(File.read("/var/www/avalon/shared/role_map_#{env}.yml"))
      result = config['group_manager'].first
    rescue
    end
    result
  end
end

Facter.add("rails_env") do
  setcode do
    result = "production"
    confs = Dir['/etc/httpd/conf.d/*avalon*.conf']
    begin
      result = File.read(confs.first).split(/\n/).find { |l| l =~ /R(ails|ack)Env/ }.split.last
    rescue
    end
    result
  end
end

def add_database_facts
  env = Facter.value("rails_env")
  database_configuration = YAML.load(File.read('/var/www/avalon/shared/database.yml'))[env]

  Facter.add("avalon_db_user") do
    setcode do
      begin
        database_configuration['username']
      rescue
        'avalonweb'
      end
    end
  end

  Facter.add("avalon_db_password") do
    setcode do
      begin
        database_configuration['password']
      rescue
        'hid2gub8em5ghaf2'
      end
    end
  end

  Facter.add("avalon_db_host") do
    setcode do
      begin
        database_configuration['host']
      rescue
        'localhost'
      end
    end
  end
end

add_database_facts