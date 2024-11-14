class SetupAccessGroup < ActiveRecord::Migration[7.2]
  def up
    # Create a personal access group for each user
    User.find_each do |user|
      access_group = AccessGroup.find_or_create_by!(name: user.name)
      user.access_groups << access_group unless user.access_groups.include?(access_group)
      user.update_column(:access_group_id, access_group.id)
    end

    # If more than one user exists create a shared access group
    access_group = nil
    if User.count > 1
      access_group = AccessGroup.find_or_create_by!(name: 'Shared')
      User.find_each do |user|
        user.access_groups << access_group unless user.access_groups.include?(access_group)
        user.update_column(:access_group_id, access_group)
      end
    elsif User.count == 1
      access_group = AccessGroup.find_by_name(User.first.name)
    end

    # Assign the ownership of all credential either to the shared access group or the personal access group
    if access_group
      Credential.update_all(access_group_id: access_group.id)
    end
  end

  def down
    # Remove the ownership
    Credential.update_all(access_group_id: nil)

    # Cleanup user records
    User.find_each do |user|
      user.update_column(:access_group_id, nil)
      user.access_groups.delete_all
    end

    # Remove all shared access groups
    AccessGroup.delete_all
  end
end
