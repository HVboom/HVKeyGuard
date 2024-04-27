module HVCrypto
  class Synchron
    def initialize(message_key = nil)
      # ensure a message_key is always set
      message_key ||= Rails.application.credentials[:message_key]
      key = ActiveSupport::KeyGenerator.new(message_key).
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
      'Wrong password'
    end
  end
end
