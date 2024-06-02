module HVCrypto
  class Synchron
    WRONG_PASSWORD = '***'

    def initialize(message_key = nil, hash_digest_class = nil)
      # ensure a message_key is always set
      message_key ||= Rails.application.credentials[:message_key]
      hash_digest_class ||= OpenSSL::Digest::SHA1 if Rails.application.credentials.fetch(:preserve_existing_data)
      key = ActiveSupport::KeyGenerator.new(message_key, hash_digest_class: hash_digest_class).
        generate_key(Rails.application.credentials[:secret_key_base], 32)
      @encryptor = ActiveSupport::MessageEncryptor.new(key)
      # Fallback to an old cipher instead of new default aes-256-gcm.
      @encryptor.rotate cipher: "aes-256-cbc"
    end

    # Encodes and signs with MessageEncryptor
    def encode(data)
      @encryptor.encrypt_and_sign(data)
    end

    # Decodes and signs with MessageEncryptor
    def decode(data)
      @encryptor.decrypt_and_verify(data)
    rescue ActiveSupport::MessageVerifier::InvalidSignature, ActiveSupport::MessageEncryptor::InvalidMessage
      WRONG_PASSWORD
    end
  end
end
