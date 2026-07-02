class CreateChats < ActiveRecord::Migration[8.1]
  def change
    create_table :chats do |t|
      t.string :name
      t.text :description
      t.integer :chat_type, default: 0, null: false

      t.timestamps
    end
  end
end
