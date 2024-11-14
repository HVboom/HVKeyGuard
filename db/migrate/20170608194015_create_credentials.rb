class CreateCredentials < ActiveRecord::Migration[7.2]
  def change
    create_table :credentials, id: :uuid do |t|
      t.string :title, null: false, comment: 'Unique name of the credential'
      t.string :url, comment: 'URL to have a direct link to access the web page'
      t.string :login, comment: 'User or email used to login to the web page'
      t.text :comment, comment: ' Additional information like password hints etc.'
      t.string :token, null: false, comment: 'Identifier for the Safe'
      t.boolean :secured, null: false, default: false, comment: 'If set the stored data is protected by an additional password'

      t.timestamps
    end
    add_index :credentials, :title, unique: true
    add_index :credentials, :token, unique: true
  end
end
