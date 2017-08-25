class CredentialSerializer < ActiveModel::Serializer
  attributes :id, :title, :url, :login, :comment, :token, :secure
end
