module HVboom::Export::Group
  include HVboom::Export

  def usage
    available_groups = AccessGroup.all.pluck(:name).sort
    puts "Not all groups are found. Available groups: #{available_groups.join(' ')}"
    puts "Usage: rake hvboom:export:groups['Demo1 Shared'] PASSWORD='Demo'"
  end
end

namespace :hvboom do
  namespace :export do
    desc """
      Export all credentials belonging to given group(s).
      
      Either provide standard password via environment variable PASSWORD
      or you will be prompted for each secured credential during the export

      Example: `rake hvboom:export:groups['Demo1 Shared'] PASSWORD='Demo'`
    """
    task :groups, [:groups] => [:environment] do |task, args| 
      include HVboom::Export::Group

      groups = args[:groups] || ENV['GROUPS']
      password = ENV['PASSWORD']
      raise ArgumentError, 'missing required argument GROUPS' if groups.blank?
      groups = groups.strip.split(' ') if groups.is_a?(::String)
      groups.map(&:strip).compact.uniq if groups.is_a?(::Array)

      group_ids = AccessGroup.where(name: groups).pluck(:id)
      if group_ids.size != groups.size
        usage
        exit(false)
      end
      credentials = Credential.access_groups(group_ids).includes(:access_group).ordered
      credentials = set_passwords(credentials, password)

      filename_prefix = "Groups_" + groups.sort.join('_')
      HVboom::CredentialExporter.new(filename_prefix, credentials).export
    end
  end
end
