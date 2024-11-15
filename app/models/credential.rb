class Credential < ApplicationRecord
  include Filterable

  # ownership of the credential
  belongs_to :access_group, optional: true

  # virtual attribute for the secured document
  attribute :document, :text
  # virtual attribute for the optional document password
  attribute :password

  # Callbacks
  before_validation :normalize_title
  before_create :set_token
  after_save :save_document
  after_destroy :reset_document

  # Validations
  validates :title,
    presence: true,
    uniqueness: { case_sensitive: false }

  # validates :token,
    # presence: true,
    # uniqueness: true

  validates :password,
    presence: true,
    if: -> { self.secured }

  validate :document_successfully_decrypted,
    if: -> { self.secured && self[:document].present? }

  scope :ordered, -> { order :title }
  scope :title_filter, -> (title) { where('lower(title) like ?', "%#{title.downcase.strip}%") }
  scope :url_filter, -> (url) { where('lower(url) like ?', "%#{url.downcase.strip}%") }
  scope :access_groups, -> (*access_groups) { where('access_group_id in (?)', *access_groups) }

  def document
    self[:document] = HVDigitalSafe::SecureDataStorage.new(self.token).document
    if self.secured
      self[:document] = HVCrypto::Synchron.new(self.password).decode(self[:document])
    end
    self[:document]
  end

  def document=(doc)
    if self.secured
      # self[:document] = HVCrypto::Synchron.new(self.password).encode(doc)
      super(HVCrypto::Synchron.new(self.password).encode(doc))
    else
      # self[:document] = doc
      super(doc)
    end
  end

  private
    def normalize_title
      self.title.strip! if self.title.present?
    end

    def set_token
      max_retries = 10
      retries = 0
    
      loop do
        self.token = HVDigitalSafe::SecureDataStorage.new.token
        break unless Credential.exists?(token: self.token)
    
        retries += 1
        if retries >= max_retries
          errors.add(:token, "could not generate a unique token after #{max_retries} attempts")
          raise ActiveRecord::RecordInvalid.new(self)
        end
      end
    end

    def save_document
      doc = self[:document]
      doc.blank? || HVDigitalSafe::SecureDataStorage.new(self.token, doc).save
    end

    def reset_document
      doc = Faker::Internet.password(min_length: 8, max_length: 20, mix_case: true, special_characters: true)
      HVDigitalSafe::SecureDataStorage.new(self.token, doc).save
    end

    def document_successfully_decrypted
      if self[:document] == HVCrypto::Synchron::WRONG_PASSWORD
        errors.add(:password, :invalid)
        errors.add(:document, :invalid)
      end
   end
end
