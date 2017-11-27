class AddAccessGroupToCredentials < ActiveRecord::Migration[5.1]
  def change
    add_reference :credentials, :access_group, foreign_key: true, comment: 'Ownership of the credential'
  end
end
