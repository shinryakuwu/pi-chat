class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    enable_extension 'citext' unless extension_enabled?('citext')

    create_table :users do |t|
      t.citext :username, null: false
      t.string :password_digest, null: false
      t.string :name
      t.text :bio

      t.timestamps
    end

    add_index :users, :username, unique: true
  end
end
