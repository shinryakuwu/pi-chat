class CreateChatMembers < ActiveRecord::Migration[8.1]
  def change
    create_table :chat_members do |t|
      t.integer :role, default: 0, null: false
      t.integer :status, default: 0, null: false
      t.references :user, null: false, foreign_key: true, index: false
      t.references :chat, null: false, foreign_key: true

      t.timestamps
    end

    add_index :chat_members, [ :user_id, :chat_id ], unique: true
  end
end
