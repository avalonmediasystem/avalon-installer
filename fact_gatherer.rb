module FactGatherer
  DEFAULT_FACTS = {
    'avalon_dropbox_user' => 'avalondrop',
    'avalon_admin_user' => 'archivist1@example.com',
    'rails_env' => 'production'
  }

  def gather_facts
    fact_file = File.expand_path('../avalon-install.yml',__FILE__)
    facts_have_changed = false

    if File.exists?(fact_file)
      @facts = YAML.load(File.read(fact_file))
    else
      @facts = DEFAULT_FACTS
      @facts['avalon_dropbox_user'] = ask("Username for Avalon Dropbox: ") do |q|
        q.validate = /.+{3}/
        q.default = @facts['avalon_dropbox_user']
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
      @facts['avalon_dropbox_password'] = passwords[0]

      @facts['avalon_admin_user'] = ask("Initial Avalon Collection/Group Manager E-Mail: ") do |q|
        q.validate = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/
        q.default = @facts['avalon_admin_user']
      end

      @facts['rails_env'] = ask("Rails environment to run under: ") do |q|
        q.case = :down
        q.default = 'production'
        q.validate = /^production|test|development$/
      end
      facts_have_changed = true
    end

    unless @facts['avalon_dropbox_password'].nil?
      salt = rand(36**8).to_s(36)
      @facts['avalon_dropbox_password_hash'] = UnixCrypt::MD5.build(@facts.delete('avalon_dropbox_password'),salt)
      facts_have_changed = true
    end

    if facts_have_changed
      File.open(fact_file,'w') { |f| f.write(YAML.dump(@facts)) }
    end

    return @facts
  end
end
