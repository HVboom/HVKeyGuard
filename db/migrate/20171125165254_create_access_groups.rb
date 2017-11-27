class CreateAccessGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :access_groups do |t|
      t.string :name, comment: 'Identifier of the access group'

      t.timestamps
    end
  end
end
