module HVboom::Export::User
  include HVboom::Export

  module User
    def usage
      available_users = User.all.pluck(:name).sort
      puts "Not all users are found. Available users: #{available_users.join(' ')}"
      puts "Usage: rake hvboom:export:users['Demo1 Demo3'] PASSWORD='Demo'"
    end
  end
end

namespace :hvboom do
  namespace :export do
    desc """
      Export all credentials belonging to given user(s).
      
      Either provide standard password via environment variable PASSWORD
      or you will be prompted for each secured credential during the export

      Example: `rake hvboom:export:users['Demo1 Demo3'] PASSWORD='Demo'`
    """
    task :users, [:users] => [:environment] do |task, args| 
      include HVboom::Export::User

      users = args[:users] || ENV['USERS']
      password = ENV['PASSWORD']
      raise ArgumentError, 'missing required argument users' if users.blank?
      users = users.strip.split(' ') if users.is_a?(::String)
      users.map(&:strip).flatten.uniq if users.is_a?(::Array)

      found_users = User.where(name: users).includes(:access_groups).order(:name)
      if found_users.size != users.size
        usage
        exit(false)
      end

      found_users.each do |user|
        group_ids = user.access_groups.pluck(:id)
        credentials = Credential.access_groups(group_ids).includes(:access_group).ordered
        puts "Set passwords for user '#{user.name}'" if password.blank?
        credentials = set_passwords(credentials, password)

        filename_prefix = "User_#{user.name}"
        HVboom::CredentialExporter.new(filename_prefix, credentials).export
      end
    end
  end
end
