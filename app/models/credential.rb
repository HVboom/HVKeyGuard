class Credential < ApplicationRecord
  include Filterable

  # ownership of the credential
  belongs_to :access_group, optional: true

  # virtual attribute for the secured document
  attribute :document, :text
  # virtual attribute for the optional document password
  attribute :password

  before_create :set_token
  after_save :save_document

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
    def set_token
      self.token = HVDigitalSafe::SecureDataStorage.new.token
    end

    def save_document
      doc = self[:document]
      doc.blank? || HVDigitalSafe::SecureDataStorage.new(self.token, doc).save
    end

    def document_successfully_decrypted
      if self[:document] == HVCrypto::Synchron::WRONG_PASSWORD
        errors.add(:password, :invalid)
        errors.add(:document, :invalid)
      end
   end
end
