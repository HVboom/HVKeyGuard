class CreateJoinTableAccessGroupUser < ActiveRecord::Migration[5.1]
  def change
    create_join_table :access_groups, :users do |t|
      t.index [:access_group_id, :user_id], name: 'access_group_and_user', unique: true
      t.index [:user_id, :access_group_id], name: 'user_and_access_group', unique: true
    end
  end
end
