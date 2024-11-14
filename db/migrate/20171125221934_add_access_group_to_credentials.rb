class AddAccessGroupToCredentials < ActiveRecord::Migration[7.2]
  def change
    add_reference :credentials, :access_group, type: :uuid, foreign_key: true, comment: 'Ownership of the credential'
  end
end
