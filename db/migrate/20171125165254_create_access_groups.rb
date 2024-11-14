class CreateAccessGroups < ActiveRecord::Migration[7.2]
  def change
    create_table :access_groups, id: :uuid do |t|
      t.string :name, comment: 'Identifier of the access group'

      t.timestamps
    end
  end
end
