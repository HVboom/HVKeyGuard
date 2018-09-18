module HVboom
  class CredentialExporter
    def initialize(filename_prefix, credentials)
      @filename_prefix = filename_prefix
      @credentials = credentials
    end

    def export
      puts "Export to '#{csv_file}' ..."
      CSV.open(csv_file, 'w', csv_options) do |csv|
        @credentials.each do |credential|
          csv << to_csv(credential)
          putc "."
        end
      end
      puts "\n#{@credentials.size} credentials exported."
    end

  private
    def csv_header
       %w(Title URL Login Document Comment Group)
    end

    def to_csv(credential)
      output = []
      output << credential.title
      output << credential.url
      output << credential.login
      output << credential.document
      output << credential.comment
      output << credential.access_group.name
      output
    end

    def csv_filename
      timestamp = Time.now.strftime('%Y%m%d_%H%M')
      [@filename_prefix, timestamp].join('_') + '.csv'
    end

    def csv_file
      Rails.root.join('tmp', csv_filename)
    end

    def csv_options
      options = {}
      options[:write_headers] = true
      options[:headers] = csv_header
      options[:col_sep] = ';'
      options[:quote_char] = "'"
      options[:force_quotes] = true
      options
    end
  end
end

