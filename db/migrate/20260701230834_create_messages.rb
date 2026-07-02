class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.text :text
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :chat, null: false, foreign_key: true
      t.references :replied_message, null: true, foreign_key: { to_table: :messages }

      t.timestamps
    end
  end
end
