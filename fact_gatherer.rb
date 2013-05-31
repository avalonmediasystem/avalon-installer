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

module FactGatherer
  def gather_facts(fact_file)
    @facts = {
      'dropbox_user' => 'avalondrop',
      'admin_user' => 'archivist1@example.com',
      'rails_env' => 'production'
    }.merge(YAML.load(File.read(fact_file))) if File.exists?(fact_file)
    return @facts if @facts[:complete]
    dbtext = <<-__EOC__
The Avalon Dropbox (no connection to dropbox.com) is a directory on the Avalon server filesystem where large 
files and batches can be placed in order to avoid having to upload them via HTTP. This installer sets up a limited, 
sftp-only dropbox user with the credentials you specify.
    __EOC__
    say(HighLine.color(dbtext, :green))

    @facts['dropbox_user'] = ask("Username for Avalon Dropbox: ") do |q|
      q.validate = /.+{3}/
      q.default = @facts['dropbox_user']
    end

    passwords = ['a','b']
    while passwords.uniq.length > 1
      passwords[0] = ask("Password for Avalon Dropbox: ") do |q|
        q.echo = 'x'
        q.validate = /.+{6}/
      end

      passwords[1] = ask("Confirm Password for Avalon Dropbox: ") do |q|
        q.echo = 'x'
      end
      if passwords.uniq.length > 1
        say("Passwords do not match")
      end
    end
    @facts['dropbox_password'] = passwords[0]

    @facts['admin_user'] = ask("Initial Avalon Collection/Group Manager E-Mail: ") do |q|
      q.validate = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
      q.default = @facts['admin_user']
    end

    @facts['rails_env'] = ask("Rails environment to run under: ") do |q|
      q.case = :down
      q.default = 'production'
      q.validate = /^production|test|development$/
    end
    facts_have_changed = true

    unless @facts['dropbox_password'].nil?
      salt = rand(36**8).to_s(36)
      @facts['dropbox_password_hash'] = UnixCrypt::SHA512.build(@facts.delete('dropbox_password'),salt)
      facts_have_changed = true
    end
    @facts[:complete] = true
    File.open(fact_file,'w') { |f| f.write(YAML.dump(@facts)) }
    return @facts
  end
end
