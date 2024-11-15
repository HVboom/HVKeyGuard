# lib/tasks/import.rake
namespace :hvboom do
  desc "Import credentials from CSV file in tmp directory"
  task import: :environment do
    require 'csv'
    require 'io/console'

    filename = ENV['filename']
    force_update = ENV['force_update'] == 'true' # Default is false unless explicitly set
    provided_password = ENV['password']

    if filename.nil?
      puts "Please provide a filename. Usage: rails hvboom:import filename=my_file.csv [force_update=true] [password=my_password]"
      exit
    end

    file_path = Rails.root.join('tmp', filename)
    unless File.exist?(file_path)
      puts "File not found: #{file_path}"
      exit
    end

    skipped_rows = []
    skipped_file = Rails.root.join('tmp', "Skipped_#{filename}")
    successful_count = 0 # Counter for successfully imported rows
    headers = nil # To store headers from the input CSV

    # Prompt for password if not provided
    def prompt_for_password(title, group_name)
      STDIN.getpass("Enter password for '#{title}' in group '#{group_name}': ")
    end

    CSV.foreach(file_path, headers: true, col_sep: ';', quote_char: "'") do |row|
      headers ||= row.headers # Capture headers from the first row
      begin
        title = row['Title'].strip
        existing_credential = Credential.find_by('LOWER(title) = ?', title.downcase)

        secured = ActiveRecord::Type::Boolean.new.cast(row['Secured'])
        password = secured ? (provided_password.presence || prompt_for_password(row['Title'], row['Group'])) : nil

        if secured && password.blank?
          puts "Skipping row: Password is required for secured credential but not provided."
          skipped_rows << row.to_h
          next
        end

        # Map access_group by name
        access_group = row['Group'] ? AccessGroup.find_by(name: row['Group']) : nil

        attributes = {
          title: title,
          url: row['URL'],
          login: row['Login'],
          comment: row['Comment'],
          secured: secured,
          access_group: access_group,
          password: password # Set password to trigger encryption in the model
        }

        credential = if existing_credential && force_update
                       existing_credential.update!(attributes.except(:document))
                       existing_credential
                     elsif existing_credential
                       puts "Skipping row with duplicate title: #{title}"
                       skipped_rows << row.to_h
                       next
                     else
                       Credential.create!(attributes.except(:document))
                     end

        # Assign document explicitly to trigger the encryption logic
        credential.document = row['Document']
        credential.save!

        successful_count += 1 # Increment counter on successful import
      rescue StandardError => e
        puts "Skipping row due to error: #{e.message}"
        skipped_rows << row.to_h
      end
    end

    # Write skipped rows to a new CSV file with headers, forcing quotes
    if skipped_rows.any?
      CSV.open(skipped_file, 'w', col_sep: ';', quote_char: "'", force_quotes: true) do |csv|
        csv << headers # Write the headers
        skipped_rows.each { |skipped_row| csv << headers.map { |header| skipped_row[header] } }
      end
      puts "Skipped rows have been written to #{skipped_file}"
    end

    # Final summary
    puts "Import completed. #{successful_count} rows successfully imported."
    puts "#{skipped_rows.count} rows were skipped." if skipped_rows.any?
  end
end