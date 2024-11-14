class AddAccessGroupToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :access_group, type: :uuid, foreign_key: true, comment: 'Default access group'
  end
end
