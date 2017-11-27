class AddAccessGroupToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :access_group, foreign_key: true, comment: 'Default access group'
  end
end
