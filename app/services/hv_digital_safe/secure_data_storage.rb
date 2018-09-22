module HVDigitalSafe
  class SecureDataStorage #  < ActiveModelSerializers::Model
    include ActiveModel::Model
    include HTTParty
    base_uri Rails.application.secrets.base_uri
    # debug_output

    # attributes :token, :document
    attr_accessor :token
    attr_accessor :document

    def initialize(token = create_token, document = nil)
      @token = token
      @document = document
    end

    def save
      patch("/", data)
    end

    def document
      get_document(@token)
    end

    private
      def create_token
        get('')[:data][:id]
      end

      def get_document(token)
        get("/#{token}")[:data][:attributes][:document]
      end

      def get(path)
        # Rails.logger.debug "Get: #{path.inspect} / #{headers}"
        response = self.class.get(path, headers: headers, format: :json)

        begin
          Rails.logger.debug "Response: #{response.parsed_response.inspect}"
          HashWithIndifferentAccess.new(response.parsed_response)
        rescue => exception
          Rails.logger.error "Try get: #{response.inspect}"
          raise exception
        end
      end

      def patch(path, data)
        response = self.class.patch(path, headers: headers, body: data)

        unless response.success?
          Rails.logger.error "Try patch: #{response.inspect}"
        end
        response.success?
      end

      def headers
        {
          'X-Api-Key': Rails.application.secrets.api_key,
          'Content-Type': 'application/vnd.api+json'
        }.freeze
      end

      def data
        # FIXME: SecureDataStorageSerializer.new(self).to_json
        data = HashWithIndifferentAccess.new
        data[:data] = HashWithIndifferentAccess.new
        data[:data][:id] = @token
        data[:data][:type] = self.class.name.demodulize.pluralize.underscore.dasherize
        data[:data][:attributes] = HashWithIndifferentAccess.new
        data[:data][:attributes][:token] = @token
        data[:data][:attributes][:document] = @document
        data.to_json
      end
    end
end
