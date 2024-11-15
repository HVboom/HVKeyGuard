module HVboom
  module Export
    require 'io/console'

    def set_passwords(credentials, password)
      credentials.each do |credential|
        if credential.secured
          unless password.blank?
            credential.password = password
          else
            credential.password = STDIN.getpass(prompt(credential))
          end
        end
      end
      credentials
    end

    private
    def prompt(credential)
      "Enter password for '#{credential.title}' belonging to group '#{credential.access_group.name}': "
    end
  end
end
